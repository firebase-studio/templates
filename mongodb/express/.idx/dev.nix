{ pkgs, ... }: {
  channel = "stable-25.05";

  packages = [
    pkgs.nodejs_20
    pkgs.npm-check-updates
  ];

  services.mongodb = {
    enable = true;
  };

  idx = {
    extensions = [
      "mongodb.mongodb-vscode"
    ];

    workspace = {
      onCreate = {
        npm-install = "npm install";
        default.openFiles = [
          "server.js" "database.js" "README.md"
        ];
      };
      onStart = {
        npm-check-updates = "ncu -u";
        npm-install = "npm install";
        start-database = "mongod --port 27017 --fork --logpath ./.idx/database.log --dbpath ./.idx/.data";
        run-server = "node server.js";
      };
    };

    previews = {
    };
  };
}