# SvelteKit Workspace Setup Instructions

This document provides the steps to set up a new SvelteKit workspace using a hybrid approach.

## 1. Install Prerequisites (Node.js)

This skill requires Node.js (LTS) and npm.

### 1.1. Verify
- `node -v`
- `npm -v`

If both commands work, go to **Step 2**.

### 1.2. Install automatically (recommended)
Run ONE of the following for your OS:

#### Windows (PowerShell)
- `powershell -ExecutionPolicy Bypass -File "skills/sveltekit/scripts/install_node_official.ps1"`

#### macOS / Linux (bash)
- `bash "skills/sveltekit/scripts/install_node_official.sh"`

Then restart your terminal session and verify.

---

## 2. Create and Configure the Project

This script first scaffolds a project with `create-svelte`, copies a base configuration, and then runs a configuration script (`init.js`) to add user-selected integrations.

```bash
# 1. Set variables from inputs
WS_NAME="{{workspace_name}}"
TEMPLATE_INPUT="{{template}}"
TYPES_INPUT="{{types}}"
ADD_PRETTIER={{prettier}}
ADD_ESLINT={{eslint}}
ADD_VITEST={{vitest}}
ADD_PLAYWRIGHT={{playwright}}

# 2. Determine Template Flag for create-svelte
if [ "$TEMPLATE_INPUT" = "minimal" ]; then
  TEMPLATE_FLAG="skeleton"
elif [ "$TEMPLATE_INPUT" = "library" ]; then
  TEMPLATE_FLAG="library"
else # demo
  TEMPLATE_FLAG="default"
fi

# 3. Build the create-svelte command
CMD="npm create svelte@latest \"$WS_NAME\" -- --name \"$WS_NAME\" --template \"$TEMPLATE_FLAG\" --types \"$TYPES_INPUT\""
if [ "$ADD_PRETTIER" = "true" ]; then CMD="$CMD --prettier"; else CMD="$CMD --no-prettier"; fi
if [ "$ADD_ESLINT" = "true" ]; then CMD="$CMD --eslint"; else CMD="$CMD --no-eslint"; fi
if [ "$ADD_VITEST" = "true" ]; then CMD="$CMD --vitest"; else CMD="$CMD --no-vitest"; fi
if [ "$ADD_PLAYWRIGHT" = "true" ]; then CMD="$CMD --playwright"; else CMD="$CMD --no-playwright"; fi

# 4. Scaffold the base project
echo "Running: $CMD"
eval "$CMD"

# 5. Navigate to Project Directory
cd "$WS_NAME"

# 6. Copy custom base configurations from template
echo "Copying custom package.json and init.js..."
cp "../templates/sveltekit/package.json" "."
cp "../templates/sveltekit/init.js" "."

# 7. Build the init.js command with integration flags
INIT_CMD="node init.js"
if [ "{{tailwindcss}}" = "true" ]; then INIT_CMD="$INIT_CMD tailwindcss=true"; fi
if [ "{{drizzle}}" = "true" ]; then INIT_CMD="$INIT_CMD drizzle=true"; fi
if [ "{{lucia}}" = "true" ]; then INIT_CMD="$INIT_CMD lucia=true"; fi
if [ "{{mdsvex}}" = "true" ]; then INIT_CMD="$INIT_CMD mdsvex=true"; fi
if [ "{{paraglide}}" = "true" ]; then INIT_CMD="$INIT_CMD paraglide=true"; fi
if [ "{{storybook}}" = "true" ]; then INIT_CMD="$INIT_CMD storybook=true"; fi

# 8. Run the integration script, which will also install dependencies
echo "Running post-scaffolding configuration: $INIT_CMD"
eval "$INIT_CMD"
```

## 3. Configure Agents Rules

This step copies the AI rules file into the new workspace.

```bash
mkdir -p ".agents/rules"
cp "../skills/sveltekit/resources/ai_rules.md" ".agents/rules/sveltekit.md"
```

## 4. Run Server / Development Environment

This command starts the development server.

```bash
npm run dev
```

