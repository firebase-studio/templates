# PHP Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install PHP (if not already installed)

This step ensures that PHP is installed on the system. If it's already present, the installation will be skipped.

```bash
# The skill will automatically detect your OS and run the correct script.
if [ "$OS" = "Windows_NT" ]; then
  ./scripts/install_php.ps1
else
  ./scripts/install_php.sh
fi
```

## 2. Create the Project

Create a new directory with the given workspace name and navigate into it.

```bash
mkdir -p {{workspace_name}}
cd {{workspace_name}}
```

## 3. Copy Template Files

Copy the PHP template files into the new directory.

```bash
cp -r ../../php/app/* .
```

## 4. Configure Agents Rules

Create the directory for the AI agent's rules. The skill will then copy the rule file into it.

```bash
mkdir -p .agents/rules
```

(The skill runner will place the content of `resources/ai_rules.md` into `.agents/rules/php.md`)
