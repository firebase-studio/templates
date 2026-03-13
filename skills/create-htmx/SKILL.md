---
name:create-htmx
description: Creates a new HTMX project with a choice of Go or Node.js backend.
inputs:
  - id: backend
    name: Select backend
    type: enum
    default: go
    options:
      go: go
      node: node
---

## When to Use This Skill

Use this skill when a user wants to start a new HTMX project and has expressed a preference for either a Go or a Node.js backend. This skill will set up a basic project structure with the chosen backend, ready for development.

## Instructions

1.  **Select Backend**
    The user will be prompted to select their preferred backend: Go or Node.js.

2.  **Project Scaffolding**
    Based on the user's selection, the appropriate backend code will be copied into the project directory. This includes a simple web server and an `index.html` file.

3.  **AI Rules**
    Custom AI rules for the selected backend will be copied into the `.idx/` directory to provide tailored assistance.

4.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to perform the following actions:
    - Install project dependencies.
    - Copy the AI rules from `resources/ai_rules.md` to `.agents/rules/htmx/go.md` and .agents/rules/htmx/node.md in the new project.

5.  **Final Verification**
    Confirm that `package.json`, `.agents/rules/htmx.md`, and `app.vue` and correct backend files (e.g., `main.go` for Go, `index.js` for Node.js) and the `index.html` file are present in the         project's root or new directory.
