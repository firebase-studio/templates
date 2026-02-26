# Next.js Workspace Setup Instructions

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

Set workspace name:
- `WS_NAME="<workspace_name>"`

Then scaffold Next.js:

```bash
# TypeScript
npx create-next-app@latest "$WS_NAME" \
  --yes \
  --ts \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --use-npm \
  --skip-install

# JavaScript
npx create-next-app@latest "$WS_NAME" \
  --yes \
  --js \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --use-npm \
  --skip-install
```

## 3. Install dependencies
cd "$WS_NAME"
npm install

## 4. Configure Agent Rules

Create: .agent/rules/nextjs.md inside the new workspace directory

Copy the content from: resources/ai_rules.md

## 5. Run server
npm run dev