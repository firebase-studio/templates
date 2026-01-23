{ pkgs, packageManager ? "pip", type ? "web", firebaseTool ? false, ... }: {
  packages = [
    pkgs.j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    cp -rf ${./.}/${packageManager}/${type} "$WS_NAME"
    chmod -R +w "$WS_NAME"
    chmod +x "$WS_NAME"/devserver.sh
    mkdir -p "$WS_NAME"/.idx
    packageManager=${packageManager} type=${type} firebaseTool=${if firebaseTool then "true" else ""} j2 ${./devNix.j2} -o "$WS_NAME"/.idx/dev.nix
    nixfmt "$WS_NAME"/.idx/dev.nix
    mv "$WS_NAME" "$out"

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"
  '';
}
