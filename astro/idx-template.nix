{pkgs, template ? "basics", version ? "latest", packageManager ? "npm", typescript ? "strict", git ? true, tailwind ? false, ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.nodePackages.pnpm
    pkgs.bun
    pkgs.j2cli
    pkgs.nixfmt
  ];

  bootstrap = ''
    mkdir "$out"
    cd "$out"
    GIT_FLAG=${if git then "--git" else "--no-git"}

    ${
      if packageManager == "npm" then "npm create astro@${version} . -- --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
      else if packageManager == "yarn" then "yarn create astro . --template ${template} --typescript ${typescript} $GIT_FLAG --no-install" 
      else if packageManager == "pnpm" then "pnpm create astro . --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
      else if packageManager == "bun" then "bun create astro . --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
      else "npm create astro@${version} . -- --template ${template} --typescript ${typescript} $GIT_FLAG --no-install"
    }

    mkdir -p ./.idx
    packageManager=${packageManager} tailwind=${if tailwind then "true" else "false"} j2 ${./devNix.j2} -o ./.idx/dev.nix
    nixfmt ./.idx/dev.nix

    cp -rf ${./.idx/airules.md} ./.idx/airules.md
    cp -rf ./.idx/airules.md ./GEMINI.md
    
    # Create eslint config
    cat <<EOF > ./eslint.config.cjs
const tseslint = require('typescript-eslint');
const astro = require('eslint-plugin-astro');
const prettier = require('eslint-config-prettier');

module.exports = [
  ...tseslint.configs.recommended,
  ...astro.configs['flat/recommended'],
  prettier,
];
EOF

    # Create prettier config
    cat <<EOF > ./.prettierrc
{
  "plugins": ["prettier-plugin-astro"],
  "overrides": [
    {
      "files": "*.astro",
      "options": {
        "parser": "astro"
      }
    }
  ]
}
EOF

    # Create prettier ignore
    cat <<EOF > ./.prettierignore
dist
.astro
EOF
    
    chmod -R u+w .

    node -e "
const fs = require('fs');
const path = require('path');
const packageJsonPath = path.join(process.cwd(), 'package.json');
console.log('Updating package.json at:', packageJsonPath);
if (fs.existsSync(packageJsonPath)) {
  console.log('package.json found. Updating...');
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf-8'));

  packageJson.scripts = {
    ...packageJson.scripts,
    'lint': 'eslint .',
    'lint:fix': 'eslint . --fix',
    'format': 'prettier --check .',
    'format:fix': 'prettier --write .'
  };

  packageJson.devDependencies = {
    ...packageJson.devDependencies,
    'typescript-eslint': 'latest',
    'eslint': '^8.0.0',
    'eslint-plugin-astro': 'latest',
    'eslint-config-prettier': 'latest',
    'prettier': 'latest',
    'prettier-plugin-astro': 'latest'
  };

  fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
  console.log('package.json updated successfully.');
} else {
  console.log('package.json not found at:', packageJsonPath);
}
"
    
    ${if packageManager == "npm" then "npm i --package-lock-only --ignore-scripts" else ""}
  '';
}

