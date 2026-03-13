# Ruby Workspace Setup Instructions

This guide walks the agent through setting up a new Ruby workspace from a GitHub template repository.

---

## 1. Prerequisites — Check & Install Ruby

Run the following command to check whether Ruby is installed:

```bash
ruby -v
```

**If Ruby is found:** note the version and continue.

**If Ruby is NOT found**, install it based on the user's OS:

- **macOS**:
  ```bash
  brew install ruby
  ```
  > If Homebrew itself is not available, install it first:
  > ```bash
  > /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  > ```

- **Ubuntu / Debian Linux**:
  ```bash
  sudo apt-get update && sudo apt-get install -y ruby-full
  ```

- **Fedora / RHEL / CentOS**:
  ```bash
  sudo dnf install -y ruby
  ```

- **Windows** (via winget):
  ```bash
  winget install RubyInstallerTeam.Ruby
  ```

After installation, confirm with `ruby -v` before continuing.

Also verify that `bundler` is available:
```bash
bundle -v
```
If not found, install it:
```bash
gem install bundler
```

---

## 2. Analyse the Repository

Use the `read_url_content` tool (or equivalent browser fetch) to inspect the public GitHub repository URL provided by the user. The default template repository is:

```
https://github.com/firebase-studio/templates/tree/main/ruby
```

Fetch the raw file tree to understand what is inside the `app` folder (i.e. everything at the repository root under `ruby/`). Identify:

- All files and folders **except** the `.idx/` directory — these will be copied into the workspace.
- The file `.idx/airules.md` — this will become `.agents/rules/ruby.md` in the workspace.

> **Note:** The `app` folder in the context of this skill means the root of the `ruby/` directory in the repository (i.e. `app.rb`, `Gemfile`, `Gemfile.lock`, `Dockerfile`, `.dockerignore`, `README.md`). Do NOT copy `.idx/` directory contents except `airules.md`.

---

## 3. Create Workspace & Copy Files

### 3a. Create the workspace directory

```bash
mkdir -p $WS_NAME
```

Replace `$WS_NAME` with the name chosen by the user (default: `ruby-app`).

### 3b. Copy template files (excluding `.idx/`)

Download and write each file from the repository's `ruby/` folder into `$WS_NAME/`, **skipping anything inside `.idx/`**.

The core files to copy from `https://raw.githubusercontent.com/firebase-studio/templates/main/ruby/` are:

| Source (raw GitHub URL)    | Destination in workspace   |
|----------------------------|----------------------------|
| `.../ruby/app.rb`          | `$WS_NAME/app.rb`          |
| `.../ruby/Gemfile`         | `$WS_NAME/Gemfile`         |
| `.../ruby/Gemfile.lock`    | `$WS_NAME/Gemfile.lock`    |
| `.../ruby/Dockerfile`      | `$WS_NAME/Dockerfile`      |
| `.../ruby/.dockerignore`   | `$WS_NAME/.dockerignore`   |
| `.../ruby/README.md`       | `$WS_NAME/README.md`       |

*Action:* Use `read_url_content` to fetch each file's raw content, then use `write_to_file` to create the corresponding file in `$WS_NAME/`.

### 3c. Copy AI rules

Fetch the `airules.md` file from the `.idx/` folder and save it as the agent rules file:

| Source                                        | Destination                          |
|-----------------------------------------------|--------------------------------------|
| `.../ruby/.idx/airules.md` (raw GitHub URL)   | `$WS_NAME/.agents/rules/ruby.md`      |

*Action:* Fetch the raw content and write it to `$WS_NAME/.agents/rules/ruby.md` (create the directory if needed).

### 3d. Add VS Code / IDE extension recommendation

Create or append to `$WS_NAME/.vscode/extensions.json` with the following content so the Shopify Ruby LSP extension is recommended:

```json
{
  "recommendations": [
    "Shopify.ruby-lsp"
  ]
}
```

---

## 4. Install Dependencies

Navigate into the workspace and run Bundler to install all gems:

```bash
cd $WS_NAME && bundle install
```

Wait for the command to complete successfully before reporting back to the user.

---

## 5. Run the Server (Optional)

Once dependencies are installed, the user can start the development server with:

```bash
ruby app.rb
```

The server will listen on `http://localhost:3000` by default (or the port set in the `PORT` environment variable).

> **Tip:** Set the `NAME` env var to personalise the greeting:
> ```bash
> NAME=Rody ruby app.rb
> ```
