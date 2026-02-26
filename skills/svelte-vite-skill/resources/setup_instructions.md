# Svelte-Vite Workspace Setup Instructions
 
This guide will walk you through creating a new Svelte-Vite project and configuring your environment.
 

## 1. Prerequisites

Before running the setup, verify the environment has the following system packages available:
- Node.js: Version 20.x or higher.

*Action:* Run `node -v` to check the installed version. If Node.js 20.x or higher is not installed, install it or prompt the user to install it before proceeding.

## 2. Create the Project
 
First, create a new Svelte-Vite project using the `create -y vite@latest` command-line tool. Append the appropriate flags based on the user's preferences gathered in Step 1 of `SKILL.md`:
- **Language**: `-ts` or `-js`


*Action:* Construct and run the command in the terminal. Example:
```bash
npx create -y vite@latest "$WS_NAME" -- --template svelte-ts
```
 
This will create a new directory named `$WS_NAME` with a Svelte-Vite starter project.
 
## 3. Install Dependencies
 
Navigate into your new project directory and install the dependencies.
 
```bash
cd $WS_NAME
npm install
```

## 4. Configure Required Extensions
Add the extensions: svelte.svelte-vscode

## 5. Configure Agent Rules
Copy the AI rules to the project's agent configuration.

*Action:* Create a file named `.agent/rules.md` inside the new workspace directory (`$WS_NAME/.agent/rules/svelte-vite.md`).
*Content Source:* Read the content from the `airules.md` resource file provided with this skill.

## 6. Run Server
Run the development server using the command

```bash
npm run dev
```
