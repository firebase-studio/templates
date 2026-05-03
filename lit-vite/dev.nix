# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05";
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_20
    pkgs.nodePackages.eslint
    pkgs.nodePackages.prettier
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "dbaeumer.vscode-eslint"
      "esbenp.prettier-vscode"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        npm-install = "npm ci --no-audit --prefer-offline --no-progress --timing";
        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "index.html" "src/my-element.js" "src/my-element.ts" ];
      };
      # To run something each time the workspace is (re)started, use the `onStart` hook
    };
    # Enable previews and define the ports to expose
    previews = {
      enable = true;
      previews = {
        web = {
          # The command to start your app
          command = ["npm" "run" "dev" "--" "--port" "$PORT"];
          # The port your app is listening on
          manager = "web";
        };
      };
    };
  };
}
