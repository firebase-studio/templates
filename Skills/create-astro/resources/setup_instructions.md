# Setup Instructions

This document outlines the steps to create a new Astro project and configure it with custom AI rules.

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

## Step 2: Create a New Astro Project

To create a new Astro project, run the following command:

```bash
npm create astro@latest {{workspace_name}} -- --template {{template}}
```

This will scaffold a new Astro project in the specified directory with the chosen template.

## Step 3: Install Dependencies

Navigate into the newly created project directory and install the dependencies:

```bash
cd {{workspace_name}} && npm install
```

## Step 4: Create AI Rules

Create a new file at `.agents/rules/astro.md` with the following content:

```
The user is building a web application with Astro, a modern front-end framework. Your primary role is to assist them in developing, debugging, and deploying their Astro project. If you need to install dependencies, use the `npm install` command. The user's project is located in the current working directory, and the application can be served by running `npm run dev`.
```

Ensure the `.agents/rules/` directory exists before creating the file.

```bash
mkdir -p .agents/rules && cat <<EOF > .agents/rules/astro.md
The user is building a web application with Astro, a modern front-end framework. Your primary role is to assist them in developing, debugging, and deploying their Astro project. If you need to install dependencies, use the `npm install` command. The user's project is located in the current working directory, and the application can be served by running `npm run dev`.
EOF
```
