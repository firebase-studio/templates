# React Native (Expo) Workspace Setup Instructions

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
bash <(curl -s "https://raw.githubusercontent.com/project-idx/official-templates/main/skills/create-react-native/scripts/install_node_official.sh")
```

Then restart your shell and verify the installation:

```bash
node -v
npm -v
```

**For Windows (PowerShell):**

```powershell
iex (irm "https://raw.githubusercontent.com/project-idx/official-templates/main/skills/create-react-native/scripts/install_node_official.ps1")
```

Then restart your terminal and verify the installation:

```bash
node -v
npm -v
```

## 2. Create the Project

First, set a variable for your workspace name:

- `WS_NAME="<workspace_name>"`

Then, use `npm create expo@latest` to scaffold the new Expo project. The `--no-install` flag is used to separate project creation from dependency installation.

*Note: The command will use the `language` and `packageManager` you selected when running the skill.*

```bash
# For TypeScript projects (default)
npm create expo@latest "$WS_NAME" -- --template blank-typescript --no-install

# For JavaScript projects
npm create expo@latest "$WS_NAME" -- --template blank --no-install
```

## 3. Install Dependencies

Navigate into your new project directory and install the dependencies using your chosen package manager.

```bash
cd "$WS_NAME"
npm install
# or: yarn install, pnpm install, bun install
```

## 4. Configure Agents Rules

Create a new file for the AI agent's rules inside the workspace directory:

- `.agents/rules/react_native.md`

Copy the content from this skill's resources into the file you just created:

- `resources/ai_rules.md`


## 5. Run the Development Server

Once dependencies are installed, you can start the Metro development server.

```bash
npm start
# or: yarn start, pnpm start, bun start
```
