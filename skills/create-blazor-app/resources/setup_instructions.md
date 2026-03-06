# Blazor App Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (.NET SDK)

This skill requires the .NET 8 SDK.

### 1.1 Verify
Run:
- `dotnet --version`

If the command works and the version is 8.0.0 or higher, go to **Step 2**.

### 1.2 Install automatically from official .NET downloads (recommended)
Use the provided prereq installer script to install the .NET SDK.

Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run:
- `powershell -ExecutionPolicy Bypass -File "scripts/install_dotnet_official.ps1"`

Then restart your terminal session and verify: `dotnet --version`

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_dotnet_official.sh"`

Then restart your shell session and verify: `dotnet --version`

> Note: The script may require `sudo` for system-wide installation.

---

## 2. Create the project

Set your workspace name:
- `WS_NAME="<workspace_name>"`

Then scaffold the Blazor app:
```bash
dotnet new blazor -o "$WS_NAME"
```

## 3. Install dependencies

Change into the project directory:
```bash
cd "$WS_NAME"
```
The `dotnet new` command automatically restores dependencies. If you need to restore them again later, you can run `dotnet restore`.

## 4. Configure Agent Rules

Create the file `.agent/rules/dotnet.md` inside the new workspace directory.

Copy the content from `resources/ai_rules.md`.

## 5. Run the server

From inside your project directory, run:
```bash
dotnet watch
```
