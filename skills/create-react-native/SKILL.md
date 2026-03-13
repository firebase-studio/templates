---
name: create-react-native-expo
description: Creates a new React Native project using Expo with optional TypeScript support and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
  - id: language
    name: Language
    type: enum
    default: ts
    options:
      js: JavaScript
      ts: TypeScript
  - id: packageManager
    name: Package Manager
    type: enum
    default: npm
    options:
      npm: npm
      yarn: yarn
      pnpm: pnpm
      bun: bun
---

## When to Use This Skill

Use this skill when the user wants to create a new React Native project using Expo, with a choice of language and package manager, and wants the project configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Expo project (using the `workspace_name`, `language`, and `packageManager` inputs).
   - Install dependencies.
   - Create the `.agents/rules/react_native.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agents/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `package.json` exists in the new project directory.
   - `.agents/rules/react_native.md` exists.
   - `App.tsx` (for TypeScript) or `App.js` (for JavaScript) exists in the project's root.
