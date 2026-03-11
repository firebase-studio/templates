# PHP Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Create the Project

Create a new directory with the given workspace name and navigate into it.

```bash
mkdir -p {{workspace_name}}
cd {{workspace_name}}
```

## 2. Copy Template Files

Copy the PHP template files into the new directory.

```bash
cp -r ../../php/app/* .
```

## 3. Configure Agent Rules

Create the directory for the AI agent's rules. The skill will then copy the rule file into it.

```bash
mkdir -p .agent/rules
```

(The skill runner will place the content of `resources/ai_rules.md` into `.agent/rules/php.md`)
