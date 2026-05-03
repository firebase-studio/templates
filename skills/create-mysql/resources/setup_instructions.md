# MySQL Workspace Setup Instructions

Follow these steps to initialize the workspace and connect to your database.

## 1. Understand the Environment

This workspace comes pre-configured with:
- A running MySQL server.
- Node.js and the `mysql2` package for connecting to the database from your application.
- The SQLTools VS Code extension for a graphical database interface.

Dependencies are installed automatically when the workspace is created via the `npm install` command in `.idx/dev.nix`.

This skill requires Node.js (LTS) and npm.

### 1.1. Verify
- `node -v`
- `npm -v`

If both commands work, go to **Step 2**.

### 1.2. Install automatically (recommended)
Run ONE of the following for your OS:

#### Windows (PowerShell)
- `powershell -ExecutionPolicy Bypass -File "skills/create-mysql/scripts/install_node_official.ps1"`

#### macOS / Linux (bash)
- `bash "skills/create-mysql/scripts/install_node_official.sh"`

Then restart your terminal session and verify.

## 2. Connect to the Database

The MySQL server is available and running. You can connect to it in two primary ways:

### 2.1 Using the Command-Line

Open a terminal in Firebase Studio and run the following command to connect as the `root` user. There is no password by default.

```bash
mysql -u root
```

You can now run SQL commands directly. For example, to see existing databases:
```sql
SHOW DATABASES;
```
To exit the client, type `exit`.

### 2.2 Using the SQLTools Extension

The SQLTools extension is pre-configured.
1.  Click on the SQLTools icon in the activity bar on the left.
2.  You should see a connection named "MySQL". Click the "Connect" button.
3.  You can now browse the database schema, run queries, and view results directly in the IDE.

## 3. Run the Sample Application

A sample Node.js script `index.js` is provided to demonstrate how to connect to the database and run a query from your application.

To run it, open a terminal and execute:
```bash
node index.js
```

## 4. Configure Agents Rules

To give the AI assistant context about your project, copy the provided rules file.

Create a new directory and file for the agents rules:

```bash
mkdir -p .agents/rules
cp skills/create-mysql/resources/ai_rules.md .agents/rules/mysql.md
```
