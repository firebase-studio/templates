# Nuxt.js Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Node.js + npm)

This skill requires:
- Node.js (recommended 18.x+)
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
- `powershell -ExecutionPolicy Bypass -File "<skill_root>/scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "<skill_root>/scripts/install_node_official.sh"`

Then restart shell and verify:
- `node -v`
- `npm -v`

> Note: macOS/Linux install may require `sudo` for system-wide installation.

---

## 2. Create the project

Set workspace name:
- `WS_NAME="<workspace_name>"`

Then scaffold Nuxt.js:

```bash
# For both TypeScript and JavaScript
npx nuxi@latest init "$WS_NAME"
```

## 3. Install dependencies
cd "$WS_NAME"
npm install

## 4. Configure Agent Rules

Create: .agent/rules/nuxtjs.md inside the new workspace directory

Copy the content from: resources/ai_rules.md

## 5. Run server
npm run dev
