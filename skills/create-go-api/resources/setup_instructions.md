# Go API Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Go)

This skill requires:
- Go (1.20+)

### 1.1 Verify
Run:
- `go version`

If it works and the version is **1.20+**, go to **Step 2**.

### 1.2 Install automatically from official Go downloads (recommended)
Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run:
- `powershell -ExecutionPolicy Bypass -File "scripts/install_go_official.ps1"`

Then restart terminal / Antigravity session and verify:
- `go version`

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_go_official.sh"`

Then restart shell and verify:
- `go version`

---

## 2. Create the project (copy template files)

Set workspace name:
- `WS_NAME="<workspace_name>"`

From the repo root (or any directory), create the folder:

```bash
mkdir -p "$WS_NAME"

- Copy the Go API template files into the workspace:

# Copy from this repo’s go/api template into the new workspace
cp -R "<skill_root>/../../go/api/." "$WS_NAME/"

Then enter the workspace:

cd "$WS_NAME"

## 3. Configure Agent Rules

Create: .agent/rules/go-api.md inside the new workspace directory.

Copy the content from: resources/ai_rules.md

Commands:

mkdir -p .agent/rules
# then create .agent/rules/go-api.md and paste contents from resources/ai_rules.md
4. Run server
go run main.go

The server runs on:

http://localhost:3000 (default)

Optional env vars:

PORT to change port

NAME to change greeting

Verify:

curl http://localhost:3000/

Expected response contains:

Hello World!