# React Native Workspace Setup Instructions

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

Then, use your preferred package manager to scaffold the Expo project. The command will vary slightly depending on whether you choose TypeScript or JavaScript.

```bash
# Using npm (TypeScript)
npm create expo@latest "$WS_NAME" -- --template blank-typescript --no-install

# Using npm (JavaScript)
npm create expo@latest "$WS_NAME" -- --template blank --no-install

# Using yarn (TypeScript)
yarn create expo "$WS_NAME" --template blank-typescript --no-install

# Using pnpm (TypeScript)
pnpm create expo "$WS_NAME" --template blank-typescript --no-install

# Using bun (TypeScript)
bun create expo "$WS_NAME" --template blank-typescript --no-install
```

## 3. Install dependencies
cd "$WS_NAME"
# Use the package manager you chose in the previous step
npm install 
# or `yarn`, `pnpm install`, `bun install`

## 4. Configure Agent Rules

Create: .agent/rules.md inside the new workspace directory

Copy the content from: resources/ai_rules.md

## 5. Run server

# Use the package manager you chose
npm start
# or `yarn start`, `pnpm start`, `bun start`
