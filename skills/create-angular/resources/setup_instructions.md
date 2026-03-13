## Angular Project Setup Instructions

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
- `powershell.exe -ExecutionPolicy Bypass -File "skills/create-angular/scripts/install_node_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `node -v`
- `npm -v`

#### macOS / Linux (bash)
Run:
- `bash "skills/create-angular/scripts/install_node_official.sh"`

Then restart shell and verify:
- `node -v`
- `npm -v`

> Note: macOS/Linux install may require `sudo` for system-wide installation.

---

**2. Create the Angular Project**

Run the following command to create a new Angular project. This command will create a new directory with the project files.

```bash
npx @angular/cli new {{workspace_name}} --routing=true --style=css --skip-tests=false --standalone=true
```

This command creates a new Angular project with the following options:
- `--routing=true`: Creates a routing module.
- `--style=css`: Uses CSS for styling.
- `--skip-tests=false`: Generates test files.
- `--standalone=true`: Creates a standalone application.

**3. Create AI Rules**

Create a new file at `.agents/rules/angular.md` with the content from `resources/ai_rules.md`.

**4. Install Dependencies**

Run the following command to install the project dependencies:

```bash
npm install
```

**5. Run the Development Server**

To view the application, run the following command to start the development server:

```bash
ng serve
```

This will start a local development server. You can then open your browser to the specified address (usually `http://localhost:4200/`) to see the running application.
