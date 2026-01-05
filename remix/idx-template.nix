{ pkgs, ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.git
  ];
  bootstrap = ''
    set -ex
    mkdir -p "$out"
    cd "$out"
    npx create-react-router@latest . --typescript --no-install --no-git-init --yes
    if [ ! -f "package.json" ]; then
      exit 1
    fi
    mkdir -p .idx
    cp -rf ${./dev.nix} .idx/dev.nix
    cp -rf ${./.idx/airules.md} .idx/airules.md
    cp -f .idx/airules.md GEMINI.md
    chmod -R u+w .
    npm install --package-lock-only --ignore-scripts
  '';
}