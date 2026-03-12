---
name: create-go-web
description: Creates a new Go web server project by copying the go/web template files and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project
---

## When to Use This Skill

Use this skill when the user wants to create a simple Go web server project (stdlib `net/http`) from the `go/web` template and run it locally with Go installed.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install prerequisites.

   *Action:* Read `resources/setup_instructions.md`.

2. **Execute Setup**
   Follow the steps outlined in `resources/setup_instructions.md` to:
   - Ensure Go is installed (Go 1.20+).
   - Create the workspace folder (using the `workspace_name` input).
   - Copy template files from `go/web` into the new workspace.
   - Create the `.agent/rules/go-web.md` file using the content from `resources/ai_rules.md`.
     - Ensure the `.agent/rules/` directory exists.

3. **Final Verification**
   Check that:
   - `server.go` exists in the new project
   - `go.mod` exists in the new project
   - `README.md` exists in the new project
   - `.agent/rules/go-web.md` exists
