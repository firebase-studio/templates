# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_20
    pkgs.unzip # Required for native development
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ionic.ionic"
      "angular.ng-template"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        npm-install = "npm ci --no-audit --prefer-offline --no-progress --timing || npm i --no-audit --no-progress --timing";
        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "src/app/app.component.ts" ];
      };
      # To run your app, use 'npm run start' in the terminal
      # and press 'Open Preview'
    };
  };
}
