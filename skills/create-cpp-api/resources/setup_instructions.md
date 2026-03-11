# C++ API Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Docker)

This skill requires:
- Docker
- Docker Compose

### 1.1 Verify
Run:
- `docker --version`
- `docker-compose --version`

If both commands work, go to **Step 2**.

### 1.2 Install Docker
Docker is required to build and run this C++ application. The installation process is OS-specific.

Please follow the official instructions for your operating system:
- **Windows:** [https://docs.docker.com/desktop/install/windows-install/](https://docs.docker.com/desktop/install/windows-install/)
- **macOS:** [https://docs.docker.com/desktop/install/mac-install/](https://docs.docker.com/desktop/install/mac-install/)
- **Linux:** [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

After installation, restart your terminal and verify again.

---

## 2. Create the project (copy template files)

Set workspace name:
- `WS_NAME="<workspace_name>"`

From the repo root (or any directory), create the folder:

```bash
mkdir -p "$WS_NAME"
```

Copy the C++ API template files into the workspace:

```bash
# Copy from this repo’s cpp/app template into the new workspace
cp -R "<skill_root>/../../cpp/app/." "$WS_NAME/"
```

Then enter the workspace:

```bash
cd "$WS_NAME"
```

## 3. Configure Agent Rules

Create a file named `.agent/rules/cpp-api.md` inside the new workspace directory.

Copy the content from: `resources/ai_rules.md`

Commands:

```bash
mkdir -p .agent/rules
# then create .agent/rules/cpp-api.md and paste contents from resources/ai_rules.md
```

## 4. Run server

From within the workspace directory, run:

```bash
docker-compose up --build
```

This will build the Docker image and start the service. The server runs on:

`http://localhost:3000`

Verify:

```bash
curl http://localhost:3000/
```

Expected response:

```
Hello, World!
```
