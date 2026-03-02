# Nuxt.js Workspace Setup Instructions

## 1. Install Prerequisites

This skill requires Node.js. Use the scripts in the `scripts/` directory to install it if needed.

### 1.1 Verify Installation
Run `node -v` to check the installed version. If it meets the requirements (e.g., 20+), proceed.

### 1.2 Install Automatically
- **Windows (PowerShell):** `powershell -ExecutionPolicy Bypass -File "scripts/install_prereqs.ps1"`
- **macOS / Linux (bash):** `bash "scripts/install_prereqs.sh"`

---

## 2. Create the Project

Set the workspace name from the skill input:
- `WS_NAME="<workspace_name>"`

Scaffold the project using `npx nuxi init`:

```bash
if [ "$LANGUAGE" == "ts" ]; then
  npx nuxi init "$WS_NAME" --typescript
else
  npx nuxi init "$WS_NAME"
fi
```

## 3. Install Dependencies

Navigate to the new project directory and install dependencies:

```bash
cd "$WS_NAME"
npm install
```

## 4. Configure Agent Rules

Create the `.agent/rules/` directory and copy the AI rules into it:

```bash
mkdir -p .agent/rules
cp ../resources/ai_rules.md .agent/rules/nuxt.md
```

## 5. Run the Development Server

Start the development server to confirm the setup:

```bash
npm run dev
```
