---
name: create-ionic
description: Creates a new Ionic aplication.
metadata:
  category: ["Mobile", "Web"]
  tags: ["ionic", "create-ionic"]
  version: "1.0.0"
  author: "Google"
---


## When to Use This Skill

     Use this skill when the user wants to create a new Ionic application.

## Instructions

    1.  **Ask for User Preferences**
        Before proceeding, you MUST ask the user for their Ionic project preferences:
        *   **Workspace Name**: The name of the new Ionic project.
        
        *Action:* Mandatorily ask the user for these preferences before doing anything else. You must also provide a clear option for the user to "Proceed with default selections". Depending on their choices, you will customize the Ionic creation command.

2.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.
    
    *Action:* Read `resources/setup_instructions.md`.

3.  **Final Verification**
    Check that `package.json` exists and the `.agent/rules/ionic.md` file is present in the new workspace.
