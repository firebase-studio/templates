{ pkgs, ... }: {
    channel = "stable-24.11";
    packages = [ pkgs.nodejs_20 ];
    bootstrap = ''
      npx --prefer-offline -y @ionic/cli start "$WS_NAME" blank --type=angular --no-deps --no-git --no-link --no-interactive
      cd "$WS_NAME"
      npm install eslint@^8.57.0 prettier@^3.2.5 eslint-config-prettier@^9.1.0 @typescript-eslint/parser@^7.8.0 @typescript-eslint/eslint-plugin@^7.8.0 @angular-eslint/builder@^18.0.0 @angular-eslint/eslint-plugin@^18.0.0 @angular-eslint/eslint-plugin-template@^18.0.0 @angular-eslint/template-parser@^18.0.0 --save-dev
      
      echo '{
        "root": true,
        "overrides": [
          {
            "files": ["*.ts"],
            "parserOptions": {
              "project": ["tsconfig.json"]
            },
            "extends": [
              "eslint:recommended",
              "plugin:@typescript-eslint/recommended",
              "plugin:@angular-eslint/recommended",
              "plugin:@angular-eslint/template/process-inline-templates",
              "prettier"
            ],
            "rules": {
              "@angular-eslint/component-class-suffix": [
                "error",
                {
                  "suffixes": ["Component", "Page"]
                }
              ]
            }
          },
          {
            "files": ["*.html"],
            "extends": [
              "plugin:@angular-eslint/template/recommended",
              "plugin:@angular-eslint/template/accessibility"
            ],
            "rules": {}
          },
          {
            "files": ["src/zone-flags.ts"],
            "rules": {
              "@typescript-eslint/no-explicit-any": "off"
            }
          }
        ]
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