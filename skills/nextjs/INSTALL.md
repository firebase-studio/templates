# Create a Next.js Project

This guide will walk you through creating a new Next.js project and configuring your environment.

## 1. Create the Project

First, create a new Next.js project using the `create-next-app` command-line tool. You can choose your preferred package manager (npm, pnpm, or yarn).

```bash
npx create-next-app@latest my-next-app
```

This will create a new directory named `my-next-app` with a Next.js starter project.

## 2. Install Dependencies

Navigate into your new project directory and install the dependencies.

```bash
cd my-next-app
npm install
```

## 3. Configure Your Environment

For the best experience in IDX, create a `.idx/dev.nix` file in your project root with the following content:

```nix
# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{pkgs}: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_20
    # Add other packages here
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        install-dependencies = "npm install";
      };
      # To run something each time the workspace is (re)started, use the `onStart` hook
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["npm" "run" "dev" "--" "--port" "$PORT" "--hostname" "0.0.0.0"];
          manager = "web";
        };
      };
    };
  };
}
```

This file tells IDX how to configure the environment for your project, including which packages to install.

## 4. Start the Development Server

You can start the development server by running:

```bash
npm run dev
```

This will start the server on port 3000. You can then open the preview to see your application.
