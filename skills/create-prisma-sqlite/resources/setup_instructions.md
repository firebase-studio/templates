# Prisma with SQLite Setup Instructions

Follow these steps to initialize the workspace.

---

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
- `powershell -ExecutionPolicy Bypass -File "skills/prisma-sqlite/scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "skills/prisma-sqlite/scripts/install_node_official.sh"`

Then restart shell and verify:
- `node -v`
- `npm -v`

> Note: macOS/Linux install may require `sudo` for system-wide installation.

---

## 2. Create the project (copy template files)

Create the project directory from the project root:

```bash
mkdir -p "${workspace_name}"
```

Copy the Prisma with SQLite template files into the workspace:

```bash
# Copy from this repo's template into the new workspace
cp -r templates/prisma/app-sqlite/* "${workspace_name}/"
```

Then enter the workspace:

```bash
cd "${workspace_name}"
```

---

## 3. Configure Agents Rules

This step copies the AI rules file into the new workspace.

```bash
mkdir -p ".agents/rules"
cp ../../skills/prisma-sqlite/resources/airules.md .agents/rules/prisma-sqlite.md
```

---

## 4. Install Dependencies

Install the necessary npm packages from within your new project directory.

```bash
npm install
```

---

## 5. Run the Application

This template comes with a pre-built SQLite database and example scripts to interact with it.

First, run the `create.ts` script to populate the database:

```bash
npx ts-node create.ts
```

Then, run the `example.ts` script to query the data:

```bash
npx ts-node example.ts
```

---
