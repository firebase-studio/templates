# Preact-Vite Project Setup Instructions

Follow these steps to initialize the project.

## 1. Install prerequisites (Node.js + npm)

This skill requires:
- Node.js (recommended 20.x+)
- npm (bundled with Node)

### 1.1 Verify
Run:
- `node -v`
- `npm -v`

If both work, go to **Step 2**.

### 1.2 Install automatically from official Node.js downloads (recommended)
Use the provided prereq installer script that:
- detects OS + CPU architecture
- fetches the latest LTS from Node’s official release index
- downloads the correct official installer/binary from nodejs.org
- installs it

Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run:
- `powershell.exe -ExecutionPolicy Bypass -File "skills/create-preact-vite/resources/scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "skills/create-preact-vite/resources/scripts/install_node_official.sh"`

Then restart shell and verify:
- `node -v`
- `npm -v`

> Note: macOS/Linux install may require `sudo` for system-wide installation.

---

## 2. Create the Preact-Vite Project

Set the workspace name:
- `WS_NAME="<workspace_name>"`

Run the following command to create a new Preact project using Vite. This command will create a new directory with the project files.

```bash
npm create vite@latest "$WS_NAME" -- --template preact-{{language}}
```

This command creates a new Preact project with the following options:
- `--template preact-{{language}}`: Uses the Preact template with either `js` or `ts`.

## 3. Create AI Rules

Create a new file at `.agent/rules/preact.md` with the content from `resources/ai_rules.md`.

## 4. Install Dependencies

Run the following command to install the project dependencies:

```bash
cd "$WS_NAME" && npm install
```

## 5. Run the Development Server

To view the application, run the following command to start the development server:

```bash
cd "$WS_NAME" && npm run dev
```

This will start a local development server. You can then open your browser to the specified address to see the running application.
