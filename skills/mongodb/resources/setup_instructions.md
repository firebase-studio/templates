# MongoDB Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Create the MongoDB Project

This step uses a setup script to scaffold the new project.

First, choose a name for your workspace (the default is `my-mongodb-project`). Then, run ONE of the following commands depending on your operating system:

**Windows (PowerShell)**

```powershell
powershell -File .\skills\mongodb\scripts\install_mongodb.ps1
```

**macOS / Linux (bash)**

```bash
bash ./skills/mongodb/scripts/install_mongodb.sh
```

This single command handles the entire project and dependency setup.

## 2. How It Works

This skill automates the entire setup of a new MongoDB database environment. There are no manual installation steps required.

The setup script creates a new project directory and copies the necessary configuration files. The `.idx/dev.nix` file included in the project tells the IDX environment to automatically install and run a MongoDB server for you.
