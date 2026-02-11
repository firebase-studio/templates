{ pkgs, ... }: {
  channel = "stable-24.11";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    npx --prefer-offline -y @angular/cli new --skip-git --defaults --skip-install --directory "$WS_NAME" "$WS_NAME"
    cd "$WS_NAME"
    npm install eslint@^8.56.0 prettier@^3.2.5 eslint-config-prettier@^9.1.0 @typescript-eslint/parser@^7.0.0 @typescript-eslint/eslint-plugin@^7.0.0 @angular-eslint/builder@^17.0.0 @angular-eslint/eslint-plugin@^17.0.0 @angular-eslint/eslint-plugin-template@^17.0.0 @angular-eslint/template-parser@^17.0.0 --save-dev
    echo '{
      "root": true,
      "parser": "@typescript-eslint/parser",
      "plugins": [
        "@typescript-eslint"
      ],
      "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:@angular-eslint/recommended",
        "prettier"
      ],
      "rules": {}
    }' > .eslintrc.json
    node -e '
const fs = require("fs");
const pkg = JSON.parse(fs.readFileSync("package.json", "utf-8"));
pkg.scripts = {
  ...pkg.scripts,
  "lint": "ng lint",
  "format": "prettier --write ."
};
fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2));
'
    cd ..
    mkdir "$WS_NAME"/.idx
    cp ${./dev.nix} "$WS_NAME"/.idx/dev.nix && chmod +w "$WS_NAME"/.idx/dev.nix
    mv "$WS_NAME" "$out"
    
    mkdir -p "$out/.idx"

    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"

    (cd "$out"; npm install --package-lock-only --ignore-scripts)
  '';
}