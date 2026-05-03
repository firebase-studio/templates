{ pkgs, language ? "js", ... }: {
  packages = [
    pkgs.nodejs_20
  ];
  bootstrap = ''
    # Create the Vite project.
    npm create -y vite@latest "$WS_NAME" -- --template ${if language == "ts" then "svelte-ts" else "svelte"}

    # Enter the newly created project directory.
    cd "$WS_NAME"

    # Create the .idx directory and copy the Nix environment file.
    mkdir -p ./.idx
    cp -f ${./dev.nix} ./.idx/dev.nix
    cp -f ${./icon.png} ./.idx/icon.png

    # Remove the default ESLint config from Vite, if it exists.
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

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"
    
    cd "$out"; npm install --package-lock-only --ignore-scripts
  '';
}
