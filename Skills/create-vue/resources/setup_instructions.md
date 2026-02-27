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

Run the following command to create the Vue with Vite project:

```bash
npm create vue@latest {{workspace_name}} -- --{{language}}
```

## 3. Install dependencies

Run the following command to install the dependencies:

```bash
cd {{workspace_name}} && npm install
```

## 4. Configure Agent Rules

Run the following command to create the `.agent/rules/vue.md` file:

```bash
mkdir -p {{workspace_name}}/.agent/rules && cat resources/ai_rules.md > {{workspace_name}}/.agent/rules/vue.md
```

## 5. Final Verification

Run the following commands to verify that the project was created successfully:

```bash
ls {{workspace_name}}/package.json
ls {{workspace_name}}/.agent/rules/vue.md
ls {{workspace_name}}/src/main.ts 2>/dev/null || ls {{workspace_name}}/src/main.js
```