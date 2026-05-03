# Prisma with PostgreSQL Setup Instructions

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
- `powershell -ExecutionPolicy Bypass -File "skills/prisma-ppg/scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "skills/prisma-ppg/scripts/install_node_official.sh"`

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

Copy the Prisma with PostgreSQL template files into the workspace:

```bash
# Copy from this repo's template into the new workspace
cp -r templates/prisma/app-ppg/* "${workspace_name}/"
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
cp ../../skills/prisma-ppg/resources/airules.md .agents/rules/prisma-ppg.md
```

---

## 4. Set up the Database

### 4.1 Create a Prisma Postgres database
You'll need to create a new project on the [Prisma Data Platform](https://console.prisma.io/) and create a new Prisma Postgres database.

### 4.2 Set the DATABASE_URL
Once your database is ready, copy the `DATABASE_URL` and add it to the `.idx/dev.nix` file. After you've done that, you'll need to rebuild the environment for the changes to take effect.

---

## 5. Run Migrations

Once your database is set up and the environment is rebuilt, run the following command in the terminal to create the database tables:

```bash
npx prisma migrate dev --name init
```

---

## 6. Run the Application

The main application logic is in `src/queries.ts`. You can run it with:

```bash
npm run queries
```

This will execute a number of CRUD queries against your database.

You can also explore Prisma Accelerate caching by running:

```bash
npm run caching
```
