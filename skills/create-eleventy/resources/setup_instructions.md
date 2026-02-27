# Eleventy Workspace Setup Instructions

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
- `powershell.exe -ExecutionPolicy Bypass -File "skills/create-eleventy/scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "skills/create-eleventy/scripts/install_node_official.sh"`

Then restart shell and verify:
- `node -v`
- `npm -v`

> Note: macOS/Linux install may require `sudo` for system-wide installation.

---

## 2. Create the project

Set workspace name:
- `WS_NAME="<workspace_name>"`

Then scaffold the project:

```bash
# Create and enter the project directory
mkdir "$WS_NAME"
cd "$WS_NAME"

# Initialize a default package.json
npm init -y
```

## 3. Install Eleventy
```bash
npm install @11ty/eleventy --save-dev
```

## 4. Create a page
Create a file named `index.md` in the root of your project:

```markdown
# Hello, Eleventy!
```

## 5. Configure Agent Rules

Create: `.agent/rules/eleventy.md` inside the new workspace directory

Copy the content from: `resources/airules.md`

## 6. Run server
```bash
npx @11ty/eleventy --serve --port=$PORT
```
