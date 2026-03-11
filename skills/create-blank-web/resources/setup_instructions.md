# Blank Web Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Node.js)

This project uses Vite, which requires Node.js (version 18.0.0 or higher) and npm.

### 1.1 Verify
Run:
- `node --version`

If the command works and the version is **18.0.0 or higher**, go to **Step 2**.

### 1.2 Install automatically
Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run:
- `powershell -ExecutionPolicy Bypass -File "scripts/install_node.ps1"`

Then restart your terminal session and verify:
- `node --version`

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_node.sh"`

Then restart your shell session and verify:
- `node --version`

---

## 2. Create the project (copy template files)

Set workspace name:
- `WS_NAME="<workspace_name>"`

From the repo root (or any directory), create the folder:

```bash
mkdir -p "$WS_NAME"
cd "$WS_NAME"
npm create vite@latest . -- --template vanilla
```
- Copy the blank web template files into the workspace:

# Copy from this repo’s blank-web template into the new workspace
cp -R "<skill_root>/../../blank-web/." "$WS_NAME/"

Then enter the workspace:

cd "$WS_NAME"

## 3. Install project dependencies

Once inside the new workspace, install the npm packages:

```bash
npm install
```

## 4. Configure Agent Rules

Create: .agent/rules/blank-web.md inside the new workspace directory.

Copy the content from: resources/ai_rules.md

Commands:

mkdir -p .agent/rules
# then create .agent/rules/blank-web.md and paste contents from resources/ai_rules.md

## 5. Run server

To start the Vite development server:

`npm run dev`

The server runs on:

http://localhost:5173 (default)

### Verify

Open http://localhost:5173 in your web browser. You should see a simple webpage with:
- A heading that says "Hello, world!"
- A button with the text "Press me"
