# Laravel Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (PHP + Composer + Node.js)

This skill requires:
- PHP (>= 8.1)
- Composer
- Node.js & npm

### 1.1 Verify
Run:
- `php -v`
- `composer --version`
- `node -v`

If all work, go to **Step 2**.

### 1.2 Install automatically
Use the provided prereq installer script that detects your OS and installs the required tools.

Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run as Administrator:
- `powershell -ExecutionPolicy Bypass -File "scripts/install_php_official.ps1"`

Then restart terminal / Antigravity session and verify.

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_php_official.sh"`

Then restart shell and verify.

> Note: The script may require `sudo` for system-wide installation.

---

## 2. Create the project

Set workspace name:
- `WS_NAME="<workspace_name>"`

Then scaffold Laravel:

```bash
composer create-project laravel/laravel "$WS_NAME"
```

## 3. Configure Project

cd "$WS_NAME"

### 3.1 Setup Environment File
```bash
cp .env.example .env
```

### 3.2 Generate App Key
```bash
php artisan key:generate
```

## 4. Install dependencies
```bash
composer install
npm install
```

## 5. Configure Agent Rules

Create: `.agent/rules/laravel.md` inside the new workspace directory

Copy the content from: `resources/ai_rules.md`

## 6. Run server
Start the backend server:
```bash
php artisan serve
```

In a separate terminal, start the frontend asset bundler:
```bash
npm run dev
```
