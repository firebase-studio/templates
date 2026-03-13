# Go Web Template Workspace Setup Instructions

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
```

Copy the Go web-template files into the workspace:

```bash
# Copy from this repo’s go/web-template template into the new workspace
cp -R "<skill_root>/../../go/web-template/." "$WS_NAME/"
```

Then enter the workspace:

```bash
cd "$WS_NAME"
```

---

## 3. Configure Agents Rules

Create: `.agents/rules/go-web-template.md` inside the new workspace directory.

Copy the content from: `resources/ai_rules.md`

Commands:

```bash
mkdir -p .agents/rules
# then create .agents/rules/go-web-template.md and paste contents from resources/ai_rules.md
```

---

## 4. Run server

Run:

```bash
go run main.go
```

Notes:
- Default address: `0.0.0.0:8080`
- If you want to bind explicitly: `go run main.go -addr localhost:8080`
- If 8080 is busy, choose another port: `go run main.go -addr localhost:3000`

Verify:

```bash
curl http://localhost:8080/
```

---

## 5. Run tests (optional)

```bash
go test ./...
```
