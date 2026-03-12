---
name: create-php-app
description: A skill to create a simple PHP application.
---

# Create a new PHP application

This skill creates a new, simple PHP application.

## 1. Install PHP

This step ensures that PHP is installed on the system.

```bash
if [ "$OS" = "Windows_NT" ]; then
  ./scripts/install_php.ps1
else
  ./scripts/install_php.sh
fi
```

## 2. Create the project

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

## 4. Configure Agent Rules

Create the directory for the AI agent's rules. The skill will then copy the rule file into it.

```bash
mkdir -p .agent/rules
```

(The skill runner will place the content of `resources/ai_rules.md` into `.agent/rules/php.md`)
