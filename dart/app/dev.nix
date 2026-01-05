# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-25.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.dart
  ];
  # Sets environment variables in the workspace
  env = { };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Dart-Code.dart-code"
    ];
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        dart-install = "dart pub get";
      };
      # Runs when a workspace is (re)started
      onStart= {
        run-server = "dart run watcher.dart";
      };
    };
  };
}