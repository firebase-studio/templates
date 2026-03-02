---
name: create-nuxt
description: Creates a new Nuxt.js project with optional TypeScript support and installs custom AI rules.
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
---

## When to Use This Skill

Use this skill when the user wants to create a new Nuxt.js project using `npx nuxi init`, with either JavaScript or TypeScript, and wants the project configured with custom AI rules.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install its dependencies.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to perform the following actions:
    - Create the Nuxt.js project using `npx nuxi init`.
    - Install project dependencies.
    - Copy the AI rules from `resources/ai_rules.md` to `.agent/rules/nuxt.md` in the new project.

3.  **Final Verification**
    Confirm that `package.json`, `.agent/rules/nuxt.md`, and `app.vue` exist in the new project directory.
