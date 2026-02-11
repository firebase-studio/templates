{ pkgs, ... }: {
  packages = [
    pkgs.nodejs_20
  ];
  bootstrap = ''
    set -e
    mkdir -p "$WS_NAME"
    npm create qwik@latest "empty" "$WS_NAME"
    
    # Pin @eslint/js to version 9 to avoid conflicts
    # with eslint-plugin-qwik
    cd "$WS_NAME"
    node -e '
      const fs = require("fs");
      const path = "package.json";
      const pkg = JSON.parse(fs.readFileSync(path, "utf-8"));
      if (pkg.devDependencies && pkg.devDependencies["@eslint/js"]) {
        console.log("Pinning @eslint/js to ^9.0.0");
        pkg.devDependencies["@eslint/js"] = "^9.0.0";
      }
      fs.writeFileSync(path, JSON.stringify(pkg, null, 2));
    '
    cd ..
    
    mkdir -p "$WS_NAME/.idx/"
    cp -rf ${./icon.png} "$WS_NAME/.idx/icon.png"
    cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"

    cd "$out"; npm install --package-lock-only --ignore-scripts
  '';
}
