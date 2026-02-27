# React Native (Expo) Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Prerequisites & Verification

This skill requires Node.js and a package manager (like npm). The development environment automatically provides these tools.

#### 1.1 Verify Installation

Run the following commands to ensure the tools are available. If both commands return a version number, you can proceed to Step 2.

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

## 4. Configure Agent Rules

Create a new file for the AI agent's rules inside the workspace directory:

- `.agent/rules/react_native.md`

Copy the content from this skill's resources into the file you just created:

- `resources/ai_rules.md`


## 5. Run the Development Server

Once dependencies are installed, you can start the Metro development server.

```bash
npm start
# or: yarn start, pnpm start, bun start
```
