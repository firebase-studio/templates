---
name: create-dart
description: Creates a new Dart project.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a new Dart project.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Create the Dart project (using the `workspace_name` input).
   - Create the `.agents/rules/dart.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agents/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `pubspec.yaml` exists in the new project
   - `.agents/rules/dart.md` exists
