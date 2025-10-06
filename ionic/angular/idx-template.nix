{ pkgs, ... }: {
  channel = "stable-24.11";
  packages = [ pkgs.nodejs_20 ];
  bootstrap = ''
    npx --prefer-offline -y @ionic/cli start "$WS_NAME" blank --type=angular --no-deps --no-git --no-link --no-interactive
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
