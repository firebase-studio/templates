# .NET API Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (.NET SDK)

This skill requires:
- .NET SDK (8.0+)

### 1.1 Verify
Run:
- `dotnet --version`

If it works and the version is **8.0+**, go to **Step 2**.

### 1.2 Install automatically from official .NET downloads (recommended)
Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run:
- `powershell -ExecutionPolicy Bypass -File "scripts/install_dotnet_sdk.ps1"`

Then restart your terminal / Antigravity session and verify:
- `dotnet --version`

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_dotnet_sdk.sh"`

Then restart your shell and verify:
- `dotnet --version`

---

## 2. Create the Project

Set the workspace name (or use the default `dotnet-api-skill`):
- `WS_NAME="<workspace_name>"`

From the repo root (or any directory), create the workspace and initialize the default project:

```bash
mkdir -p "$WS_NAME"
cd "$WS_NAME"
dotnet new webapi
```

## 3. Simplify to "Hello World"

The default template is more complex than needed. Overwrite the `Program.cs` file to create a minimal "Hello World" API.

**Action:** Overwrite the file `Program.cs` in the new workspace with the following content.

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.Run();
```

## 4. Configure Agent Rules

Create the `.agent/rules/dotnet-api.md` file inside the new workspace directory.

Copy the content from `skills/create-dotnet-api/resources/ai_rules.md`.

```bash
mkdir -p .agent/rules
# Then, create .agent/rules/dotnet-api.md and paste the contents from resources/ai_rules.md
```

## 5. Run the server

```bash
dotnet run
```

The server will run on the URLs specified in `Properties/launchSettings.json`. By default, this is typically:

- `http://localhost:5181`
- `https://localhost:7219`

### Verify:

Check the root endpoint:

```bash
curl http://localhost:5181/
```

Expected response will be the string: `Hello World!`
