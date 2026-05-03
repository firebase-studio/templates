{ pkgs, type, ... }: {
  channel = "stable-25.05";
  packages = [ 
    pkgs.nodejs
    pkgs.j2cli
    pkgs.nixfmt
   ];
  bootstrap = ''
    npx --prefer-offline -y @ionic/cli start "$WS_NAME" blank --type "${type}" --no-deps --no-git --no-link --no-interactive
    mv "$WS_NAME" "$out"
    mkdir -p "$out/.idx"
    type=${type} j2 ${./devNix.j2} -o "$out/.idx/dev.nix"
    chmod -R u+w "$out"
    cp ${./.idx/airules.md} "$out/.idx/airules.md"
    cp ${./.idx/airules.md} "$out/GEMINI.md"
    chmod -R u+w "$out"
    (cd "$out"; npm install --package-lock-only --ignore-scripts)
  '';
}