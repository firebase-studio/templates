# Gemini Workspace Setup Instructions

This guide walks the agent through setting up a new Gemini workspace.

---

## 1. Prerequisites — Check & Install Runtime

> **All prerequisite installation is handled by a dedicated script.**
> The agent must run the script below; do **not** attempt to install runtimes manually.

### 1a. Run the Prerequisites Script

The script is located at `scripts/install_prerequisites.sh` inside this skill folder.

**Run it with:**

```bash
bash scripts/install_prerequisites.sh <stack>
```

Replace `<stack>` with the user's chosen key (`js-web`, `js-web-genkit`, `py-web`, `py-notebook`, or `go-web`).

---

### 1b. What the Script Does

| Step | Action |
|---|---|
| **Detect OS** | Identifies macOS, Debian/Ubuntu, or Fedora/RHEL |
| **Check runtime** | Tests if the required binary exists; installs it if missing |
| **Set PATH** | Appends the runtime's bin directory to the user's shell profile (persistent) |

Runtimes installed per stack:

| Stack | Runtime installed |
|---|---|
| `js-web`, `js-web-genkit` | Node.js (via Homebrew or nvm) + npm |
| `py-web`, `py-notebook` | Python 3 + pip |
| `go-web` | Go |

---

### 1c. How PATH is Configured (Persistent, per Shell)

The script permanently adds the runtime's executable directory to `PATH` by appending an export line to the user's shell profile. No manual editing is required.

| Shell | Profile file modified |
|---|---|
| `zsh` | `~/.zshrc` |
| `bash` (macOS) | `~/.bash_profile` |
| `bash` (Linux) | `~/.bashrc` |
| Other | `~/.profile` |

The line added looks like:

```bash
# Added by install_prerequisites.sh (Gemini)
export PATH="/path/to/runtime/bin:$PATH"
```

> **After the script finishes**, if the runtime was freshly installed, instruct the user to reload their shell:
> ```bash
> source ~/.zshrc   # or the profile file shown in the script output
> ```
> Or open a new terminal — the commands will be available immediately.

---

### 1d. Verifying the Result

After the script completes, verify the runtime is on `PATH`:

| Stack | Commands |
|---|---|
| `js-web`, `js-web-genkit` | `node -v` and `npm -v` |
| `py-web`, `py-notebook` | `python3 --version` and `pip3 --version` |
| `go-web` | `go version` |

All commands must return a version string before proceeding to the next step.

---

## 2. Analyse the Repository

Use the `read_url_content` tool (or equivalent browser fetch) to inspect the public GitHub repository URL for the chosen stack. The template repository URL is:

```
https://github.com/firebase-studio/templates/tree/main/gemini/<stack>
```

Fetch the file tree to identify:

- All files and folders **except** the `.idx/` directory — these will be copied into the workspace.
- The file `.idx/airules.md` — this will become `.agents/rules/airules.md` in the workspace.

> **Do NOT copy** any other `.idx/` contents.

If the LangChain overlay is selected, also inspect:

```
https://github.com/firebase-studio/templates/tree/main/gemini/langchain-overlay/<stack>
```

Identify the additional or replacement files it contains — these will be layered on top of the base template files (overwriting where names match).

> **Copy all files and folders found in the repository root — except the `.idx/` directory.**
> Use `read_url_content` on the GitHub tree URL to get the authoritative, up-to-date file list, then copy everything listed there, skipping `.idx/`.

---

## 3. Create Workspace & Copy Files

### 3a. Create the workspace directory

```bash
mkdir -p $WS_NAME
mkdir -p $WS_NAME/.agents/rules
```

Replace `$WS_NAME` with the name chosen by the user (default: `my-app`).

### 3b. Copy template files (excluding `.idx/`)

*Action:* For each file identified in Section 2, use `read_url_content` to fetch the file's raw content from:

```
https://raw.githubusercontent.com/firebase-studio/templates/main/gemini/<stack>/<file-path>
```

Then use `write_to_file` to create the corresponding file inside the workspace, preserving the original sub-directory structure.

**Skip** anything inside `.idx/` — except `airules.md` (handled in 3c).

### 3c. Copy AI rules

Fetch `.idx/airules.md` and save it as the agent rules file:

| Source | Destination |
|---|---|
| `https://raw.githubusercontent.com/firebase-studio/templates/main/gemini/<stack>/.idx/airules.md` | `$WS_NAME/.agents/rules/airules.md` |

*Action:* Use `read_url_content` to fetch, then `write_to_file` to write.

### 3d. Apply LangChain overlay (if selected)

If `$LANGCHAIN=yes`, repeat the same `read_url_content` → `write_to_file` process for files from:

```
https://raw.githubusercontent.com/firebase-studio/templates/main/gemini/langchain-overlay/<stack>/<file-path>
```

Place them in the same workspace paths. If a file already exists, **overwrite** it — the LangChain version takes precedence.

---

## 4. Install Dependencies

Navigate into the workspace and run the appropriate install command:

### Node.js (`js-web`, `js-web-genkit`)

```bash
cd $WS_NAME && npm install
```

### Python (`py-web`, `py-notebook`)

```bash
cd $WS_NAME
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Go (`go-web`)

```bash
cd $WS_NAME && go mod tidy
```

Wait for the command to complete successfully before proceeding.

---

## 5. IDE Extension Recommendations

Create `$WS_NAME/.vscode/extensions.json` with the content below for the selected stack.

### `go-web`

```json
{
  "recommendations": [
    "golang.go"
  ]
}
```

### `py-notebook`

```json
{
  "recommendations": [
    "ms-toolsai.jupyter",
    "ms-python.python"
  ]
}
```

### `py-web`

```json
{
  "recommendations": [
    "ms-python.python"
  ]
}
```

### `js-web` / `js-web-genkit`

No extensions required — skip this step.

---

## 6. Verification Checklist

After setup, confirm that all required files exist inside `$WS_NAME`:

| Stack | File 1 | File 2 | File 3 |
|---|---|---|---|
| `js-web` | `package.json` | `main.js` | — |
| `js-web-genkit` | `package.json` | `static/main.js` | — |
| `py-web` | `requirements.txt` | `main.py` | `web/main.js` |
| `py-notebook` | `requirements.txt` | `main.ipynb` | — |
| `go-web` | `go.mod` | `cmd/web/main.go` | — |

If any required file is missing, re-fetch it from the raw GitHub URL (Section 3b) and re-write it.
