{ pkgs, language ? "ts", ... }:

{
  # Use a recent channel to get a newer Node.js version required by modern ESLint.
  channel = "stable-24.05";

  packages = [
    pkgs.nodejs_20
  ];

  # This bootstrap script is run once when the template is created.
  bootstrap = ''
    # Create the Vite project. This creates a directory with the workspace name.
    ${pkgs.nodejs_20}/bin/npm create -y vite@latest "$WS_NAME" -- --template ${if language == "ts" then "preact-ts" else "preact"}

    # Enter the newly created project directory.
    cd "$WS_NAME"

    # The file to patch depends on whether the user chose TypeScript or JavaScript.
    APP_FILE="src/app.jsx"
    if [ "${language}" = "ts" ]; then
      APP_FILE="src/app.tsx"
    fi

    # Use `sed` to add `rel="noreferrer noopener"` to all links with `target="_blank"`.
    # This fixes a security vulnerability and satisfies the ESLint rule.
    # We use a temporary file for compatibility with `sed` on different platforms.
    sed 's/target="_blank"/target="_blank" rel="noreferrer noopener"/g' "$APP_FILE" > "$APP_FILE.tmp" && mv "$APP_FILE.tmp" "$APP_FILE"

    # Create the .idx directory and copy the Nix environment file.
    mkdir -p ./.idx
    cp -f ${./dev.nix} ./.idx/dev.nix

    # Remove the default ESLint config from Vite.
    rm -f ./.eslintrc.cjs

    # Copy our modern ESLint config from the template root.
    cp -f ${./.idx/eslint.config.js} ./eslint.config.js

    # Copy and run the script to update package.json with new dependencies and scripts.
    cp -f ${./.idx/update-pkg.js} ./update-pkg.js
    ${pkgs.nodejs_20}/bin/node ./update-pkg.js
    rm ./update-pkg.js # Clean up the script.

    # Install all dependencies.
    ${pkgs.nodejs_20}/bin/npm install

    # Go back to the parent directory.
    cd ..

    # Move the completed project to the $out directory, which is what Nix expects.
    mv "$WS_NAME" "$out"
  '';

  # The devenv shell hook is run every time the environment is activated.
  shell.hook = ''
    echo "Welcome to your Preact + Vite project! ⚡️"
    echo "Run 'npm run dev' to start the development server."
  '';
}
