---
name: create-prisma-ppg
description: Creates a new Prisma project with a PostgreSQL database on Prisma Data Platform.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project.
    default: my-prisma-ppg-app
---

## When to Use This Skill

Use this skill to create a new Prisma project configured to work with a PostgreSQL database hosted on the Prisma Data Platform.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project, check for prerequisites, set up the database, and run the application.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Create the project directory and copy the template files.
    - Create the `.agents/rules/prisma-ppg.md` file using the content from `resources/airules.md`.
    - Set up the database, install dependencies, and run migrations.

3.  **Final Verification**
    Check that:
    - `package.json` exists in the new project.
    - `.agents/rules/prisma-ppg.md` exists.
    - The template repository files exist in the new project directory.
