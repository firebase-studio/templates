# Vue with Vite Workspace Setup Instructions

Follow these steps to initialize the workspace.

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
- `powershell -ExecutionPolicy Bypass -File "scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_node_official.sh"`

Then restart shell and verify:
- `node -v`
- `npm -v`

> Note: macOS/Linux install may require `sudo` for system-wide installation.

---

## 2. Create the project

First, set a variable for your workspace name:
- `WS_NAME="<workspace_name>"`

Then, run one of the following commands to scaffold your Vue project:

```bash
# For a TypeScript project
npm create vue@latest "$WS_NAME" -- --ts

# For a JavaScript project
npm create vue@latest "$WS_NAME" -- --js
```

## 3. Install dependencies

Navigate into your new project directory and install the dependencies.

```bash
cd "$WS_NAME"
npm install
```

## 4. Configure Agents Rules

Run the following command to create the required `.agents/rules/vue.md` file inside your new workspace directory:

```bash
mkdir -p .agents/rules && cat ../skills/create-vue/resources/ai_rules.md > .agents/rules/vue.md
```

## 5. Run the dev server

Your project is now ready. Start the development server by running:

```bash
npm run dev
```
