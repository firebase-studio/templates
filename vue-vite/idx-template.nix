{ pkgs, language ? "js", ... }:

let
  node = pkgs.nodejs_20;
in
{
  packages = [
    node # Make this version of Node.js available in the environment.
  ];
  bootstrap = ''
    # Create the initial Vite project using the correct npm from our selected node package.
    mkdir -p "$WS_NAME"
    ${node}/bin/npm create -y vite@latest "$WS_NAME" -- --template ${if language == "ts" then "vue-ts" else "vue"}

    # Enter the new project directory.
    cd "$WS_NAME"

    # Remove the default ESLint config file created by Vite.
    rm -f ./.eslintrc.cjs

    # Copy our custom ESLint and Prettier configs from the template's .idx directory.
    cp -f ${./.idx/eslint.config.js} ./eslint.config.js
    cp -f ${./.idx/update-pkg.js} ./update-pkg.js

    # Run the helper script to update package.json using the correct node.
    ${node}/bin/node ./update-pkg.js
    rm ./update-pkg.js # Clean up the script after use.

    # Now, install the updated dependencies using the correct npm.
    ${node}/bin/npm install --no-audit --prefer-offline --no-progress --timing

    # Go back to the original directory to finalize the template setup.
    cd ..

    # Standard IDX template finalization steps.
    mkdir -p "$WS_NAME/.idx/"
    cp -rf ${./icon.png} "$WS_NAME/.idx/icon.png"
    cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"

    # Set final permissions and copy over AI rules.
    chmod -R u+w "$out"
    mkdir -p "$out/.idx"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"
  '';
}