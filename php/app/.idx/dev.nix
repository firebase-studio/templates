# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.php
    pkgs.phpPackages.composer
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
    ];
    workspace = {
      onCreate = {
        # Open editors for the following files by default, if they exist:
        default.openFiles = ["index.php"];
      };
      # Runs when a workspace is (re)started
      onStart= {
        run-server = "php -S localhost:3000 index.php";
      };
    };
  };
}