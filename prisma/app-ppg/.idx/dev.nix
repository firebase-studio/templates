# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-25.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs
    pkgs.openssl
  ];

  # Sets environment variables in the workspace
  env = {
    DATABASE_URL="";
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Prisma.prisma"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        npm-install = "npm i --no-audit --prefer-offline";
        # init-db = "npx prisma@6.3.0-dev.9 init --db"; # auto-creation of DBs will be enabled soon
        default.openFiles = [ "README.md" ];
      };
      # Runs when the workspace is (re)started
      onStart = {
        setup-instructions = "echo \"Follow the instructions in the README to set up your Prisma Postgres database for this project.\"";
      };
    };
  };
}

