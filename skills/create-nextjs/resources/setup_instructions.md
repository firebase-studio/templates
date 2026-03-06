# Next.js Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Node.js + npm)

This skill requires Node.js (recommended 20.x+) and npm (which is bundled with Node).

### 1.1. Verify Installation

First, check if the tools are already available. If both commands return a version number, you can proceed to Step 2.

```bash
node -v
npm -v
```

### 1.2. Automatic Installation (Recommended)

If Node.js or npm are not installed or are outdated, use one of the following commands to automatically install the latest LTS version of Node.js.

**For macOS or Linux (bash):**

```bash
bash scripts/install_node_official.sh
```

Then restart your shell and verify the installation:

```bash
node -v
npm -v
```

**For Windows (PowerShell):**

```powershell
./scripts/install_node_official.ps1
```

Then restart your terminal and verify the installation:

```bash
node -v
npm -v
```

## 2. Create the Project

First, set a variable for your workspace name:

- `WS_NAME="<workspace_name>"`

Then, use `npx create-next-app@latest` to scaffold the new Next.js project. 

*Note: The command will use the `language` you selected when running the skill.*

```bash
# Build the create-next-app command based on user inputs
if [ "{{language}}" = "ts" ]; then
  CREATE_CMD="npx create-next-app@latest \"$WS_NAME\" --ts --use-npm --import-alias \"@/*\""
else
  CREATE_CMD="npx create-next-app@latest \"$WS_NAME\" --use-npm --import-alias \"@/*\""
fi

if [ "{{srcDir}}" = "true" ]; then
  CREATE_CMD="$CREATE_CMD --src-dir"
fi

if [ "{{eslint}}" = "true" ]; then
  CREATE_CMD="$CREATE_CMD --eslint"
else
  CREATE_CMD="$CREATE_CMD --no-eslint"
fi

if [ "{{app}}" = "true" ]; then
  CREATE_CMD="$CREATE_CMD --app"
fi

if [ "{{tailwind}}" = "true" ]; then
  CREATE_CMD="$CREATE_CMD --tailwind"
fi

eval $CREATE_CMD
```

## 3. Install Dependencies

Navigate into your new project directory and install the dependencies.

```bash
cd "$WS_NAME"
npm install --package-lock-only --ignore-scripts
```

## 4. Configure Agent Rules

Create the directory for the AI agent's rules. The skill will then copy the rule file into it.

```bash
mkdir -p .agent/rules
```

(The skill runner will place the content of `resources/ai_rules.md` into `.agent/rules/nextjs.md`)


## 5. Run the Development Server

Once dependencies are installed, you can start the Next.js development server.

```bash
npm run dev
```
