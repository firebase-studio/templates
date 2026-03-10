---
name: create-mysql-app
description: Initializes a new project with a sample Node.js application pre-configured to connect to a MySQL database and installs custom AI rules.
inputs: []
---

## When to Use This Skill

Use this skill when the user wants to set up a new project with a ready-to-use MySQL database connection and a sample Node.js application.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instruction.md) to understand how to connect to the database and run the sample application.

    *Action:* Read `resources/setup_instruction.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instruction.md` to:
    - Install dependencies via `npm install` (this is usually handled automatically by the environment).
    - Create the `.agent/rules/mysql.md` file using the content from `resources/ai_rules.md`.
      - Ensure the `.agent/rules/` directory exists.

3.  **Final Verification**
    Check that:
    - `package.json` exists.
    - `index.js` exists.
    - `.agent/rules/mysql.md` exists.
    - The MySQL service is running (you can verify by trying to connect).
