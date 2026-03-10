---
name: create-gemini
description: Scaffolds a Gemini AI application.

metadata:
  category: ["AI", "Gemini", "Fullstack"]
  tags: ["gemini", "genkit", "flask", "vite", "go", "langchain", "ai"]
  version: "1.0.0"
  author: "Google"
---

## When to Use This Skill

Use this skill when the user wants to:
- Create a Gemini app / Gemini AI project
- Scaffold a Gemini JavaScript web app (Vite or Genkit)
- Set up a Gemini Python web app or notebook
- Build a Gemini Go web app
- Use the word **gemini** in the context of starting a new project

---

## Instructions

### 1. Ask User Preferences

Prompt the user with all three questions at once:

> "Which tech stack would you like to use?
>
> | # | Key             | Description                 | Prerequisites |
> |---|-----------------|-----------------------------|---------------|
> | 1 | `js-web`        | JavaScript Web App (Vite)   | Node.js       |
> | 2 | `js-web-genkit` | JavaScript Web App (Genkit) | Node.js       |
> | 3 | `py-web`        | Python Web App (Flask)      | Python 3      |
> | 4 | `py-notebook`   | Python Notebook             | Python 3      |
> | 5 | `go-web`        | Go Web App                  | Go            |
>
> Would you like to add the **LangChain overlay**? (yes / no)
>
> What would you like to name your workspace? (default: `my-app`)"

Store the answers as `$STACK`, `$LANGCHAIN` (`yes`/`no`), and `$WS_NAME`.  
Workspace root will be: `$WS_NAME`

---

### 2. Check & Install Prerequisites

Before doing anything else, verify that the required runtime is available — and ensure its executables are permanently on `PATH`.

*Action:* Run the prerequisites script located at `scripts/install_prerequisites.sh` inside this skill folder:

```bash
bash scripts/install_prerequisites.sh <stack>
```

Replace `<stack>` with the user's chosen key (e.g. `js-web`).

The script handles:
- Detecting the OS (macOS, Debian/Ubuntu, Fedora/RHEL)
- Installing Node.js (via Homebrew or nvm), Python 3, or Go — if missing
- Permanently adding the runtime's bin directory to `PATH` in the user's shell profile (`~/.zshrc`, `~/.bashrc`, `~/.profile`) — only if not already present

After it completes, verify the runtime:

| Stack                     | Verify command                             |
|---------------------------|--------------------------------------------|
| `js-web`, `js-web-genkit` | `node -v` and `npm -v`                     |
| `py-web`, `py-notebook`   | `python3 --version` and `pip3 --version`   |
| `go-web`                  | `go version`                               |

If any binary was just installed, the user may need to run `source ~/.zshrc` (or equivalent) or open a new terminal.

For full details see **Section 1** in `resources/setup_instructions.md`.

---

### 3. Analyse the Repository

Fetch and inspect the file listing of the chosen stack's GitHub URL so you understand the template structure before copying anything.

*Action:* Use the `read_url_content` tool on:

```
https://github.com/firebase-studio/templates/tree/main/gemini/<stack>
```

Identify:
- All files and folders **except** the `.idx/` directory — these will be copied into the workspace.
- The file `.idx/airules.md` — this will become `.agent/rules/airules.md` in the workspace.

If the LangChain overlay is selected (`$LANGCHAIN=yes`), also inspect:

```
https://github.com/firebase-studio/templates/tree/main/gemini/langchain-overlay/<stack>
```

For the expected file structure per stack see **Section 2** in `resources/setup_instructions.md`.

---

### 4. Create Workspace & Copy Files

Create the workspace directory and copy all required template files.

*Action:* Follow **Section 3 (Create Workspace & Copy Files)** in `resources/setup_instructions.md`.

Key rules:
- ✅ Copy all files **except** anything inside `.idx/`
- ✅ Exception: fetch `.idx/airules.md` and write it to `$WS_NAME/.agent/rules/airules.md`
- ✅ Preserve sub-directory structure
- ✅ Use `read_url_content` to fetch each file's raw content, then `write_to_file` to create it in the workspace
- If `$LANGCHAIN=yes`: also copy files from the `langchain-overlay/<stack>` path — **overwrite** any files with the same name

---

### 5. Install Dependencies

Navigate into the workspace and install dependencies.

*Action:* Follow **Section 4 (Install Dependencies)** in `resources/setup_instructions.md`.

| Stack | Command |
|---|---|
| `js-web`, `js-web-genkit` | `npm install` |
| `py-web`, `py-notebook` | `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt` |
| `go-web` | `go mod tidy` |

---

### 6. Add IDE Extension Recommendations

*Action:* Create `$WS_NAME/.vscode/extensions.json` with the stack-appropriate content:

| Stack                     |    Extensions                            |
|---------------------------|------------------------------------------|
| `go-web`                  | `golang.go`                              |
| `py-notebook`             | `ms-toolsai.jupyter`, `ms-python.python` |
| `py-web`                  | `ms-python.python`                       |
| `js-web`, `js-web-genkit` | *(none required — skip this step)* |

For the exact JSON see **Section 5** in `resources/setup_instructions.md`.

---

### 7. Final Verification

Confirm the workspace is correctly set up by checking that the following files exist inside `$WS_NAME`:

| Stack           | Required files                               |
|-----------------|----------------------------------------------|
| `js-web`        | `package.json`, `main.js`                    |
| `js-web-genkit` | `package.json`, `static/main.js`             |
| `py-web`        | `requirements.txt`, `main.py`, `web/main.js` |
| `py-notebook`   | `requirements.txt`, `main.ipynb`             |
| `go-web`        | `go.mod`, `cmd/web/main.go`                  |

If any required file is missing, re-fetch it from the raw GitHub URL and re-write it.

Once all checks pass, inform the user their workspace is ready and recommend setting `$WS_NAME` as their active workspace.
