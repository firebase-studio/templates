{ pkgs, language ? "js", ... }:

let
  node = pkgs.nodejs_20;
in
{
  packages = [
    node
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    ${node}/bin/npm create -y vite@latest "$WS_NAME" -- --template ${if language == "ts" then "react-ts" else "react"}

    # Enter the new project directory to add our customizations.
    cd "$WS_NAME"

    # Fix the target="_blank" security issue in the generated App file.
    APP_FILE="src/App.jsx"
    if [ "${language}" = "ts" ]; then
      APP_FILE="src/App.tsx"
    fi
    if [ -f "$APP_FILE" ]; then
      sed -i 's/target="_blank"/target="_blank" rel="noreferrer"/g' "$APP_FILE"
    fi

    # Remove the default ESLint config file created by Vite.
    rm -f ./.eslintrc.cjs

    # Copy our custom ESLint config from the template's .idx directory.
    cp -f ${./.idx/eslint.config.js} ./eslint.config.js

    # Copy and run the helper script to update package.json using the correct node.
    cp -f ${./.idx/update-pkg.js} ./update-pkg.js
    ${node}/bin/node ./update-pkg.js
    rm ./update-pkg.js # Clean up the script after use.

    # Return to the root to continue the standard template setup.
    cd ..

    # Standard IDX template finalization steps.
    mkdir -p "$WS_NAME/.idx/"
    cp -rf ${./icon.png} "$WS_NAME/.idx/icon.png"
    cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"

    # Set final permissions and copy over AI rules.
    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"

    # Generate the package-lock.json file without running scripts.
    cd "$out"; npm install --package-lock-only --ignore-scripts
  '';
}