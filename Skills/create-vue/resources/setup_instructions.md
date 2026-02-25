# Vue with Vite Project Setup

## 1. Create the Vue with Vite project

Run the following command to create the Vue with Vite project:

```bash
npm create vue@latest {{workspace_name}} -- --{{language}}
```

## 2. Install dependencies

Run the following command to install the dependencies:

```bash
cd {{workspace_name}} && npm install
```

## 3. Create the .agent/rules/vue.md file

Run the following command to create the `.agent/rules/vue.md` file:

```bash
mkdir -p {{workspace_name}}/.agent/rules && cat resources/ai_rules.md > {{workspace_name}}/.agent/rules/vue.md
```

## 4. Final Verification

Run the following commands to verify that the project was created successfully:

```bash
ls {{workspace_name}}/package.json
ls {{workspace_name}}/.agent/rules/vue.md
ls {{workspace_name}}/src/main.ts 2>/dev/null || ls {{workspace_name}}/src/main.js
```
