{ pkgs, ... }: {
  packages = [
    pkgs.nodejs_20 # Use the stable Node.js v20
  ];
  bootstrap = ''
    # 1. Create and enter the project directory
    mkdir "$WS_NAME"
    cd "$WS_NAME"

    # 2. Initialize a default package.json
    npm init -y

    # 3. Install Eleventy and compatible linting/formatting dependencies
    npm install @11ty/eleventy --save-dev
    npm install eslint@8 prettier eslint-config-prettier --save-dev

    # 4. Update transitive dependencies to their latest non-breaking versions
    npm update

    # 5. Create the main content file
    echo '# Hello World!' > index.md

    # 6. Create the correct .eslintrc.js config file for ESLint v8
    echo 'module.exports = {
      env: {
        browser: true,
        es2021: true,
        node: true,
      },
      extends: ["eslint:recommended", "prettier"],
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
      },
      rules: {},
      ignorePatterns: [".idx/", "node_modules/", "_site/", "eleventy.config.js"],
    };' > .eslintrc.js

    # 7. Use Node.js to programmatically add the correct scripts to package.json
    node -e '
const fs = require("fs");
const pkg = JSON.parse(fs.readFileSync("package.json", "utf-8"));
pkg.scripts = {
  "start": "npx @11ty/eleventy --serve",
  "build": "npx @11ty/eleventy",
  "lint": "eslint .",
  "format": "prettier --write ."
};
fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2));
'

    # 8. Create the .idx directory and copy the dev.nix file into it
    mkdir -p ".idx"
    cd ..
    cp ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"

    # 9. Copy AI rules and set final permissions
    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"

    # 10. Generate the package-lock.json file
    cd "$out"; npm install --package-lock-only --ignore-scripts
  '';
}
