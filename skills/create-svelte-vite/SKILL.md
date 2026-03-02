---
name: create-svelte-vite
description: Creates a new Svelte + Vite app with optional TypeScript support and installs custom AI rules.
metadata:
  category: ["Web app"]
  tags: ["svelte-vite", "create-svelte-vite"]
  version: "1.0.0"
  author: "Google"
---


## When to Use This Skill

     Use this skill when the user wants to create a new Svelte + Vite app with optional TypeScript support.

## Instructions

1.  **Ask for User Preferences**
    Before proceeding, you MUST ask the user for their svelte-vite project preferences:
    *   **Language**: TypeScript (default) or JavaScript?
    
    *Action:* Mandatorily ask the user for these preferences before doing anything else. You must also provide a clear option for the user to "Proceed with default selections". Depending on their choices, you will customize the svelte-vite creation command.

2.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.
    
    *Action:* Read `resources/setup_instructions.md`.

3.  **Final Verification**
    Check that `package.json` exists and the `.agent/rules/svelte_vite.md` file is present in the new workspace.
