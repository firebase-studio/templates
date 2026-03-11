---
name: create-sveltekit
description: Creates a new SvelteKit project with a wide range of selectable integrations.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new project.
    default: my-sveltekit-app
  - id: template
    name: Template
    type: enum
    description: The SvelteKit template to start with.
    default: minimal
    options:
      demo: Demo app
      minimal: Minimal app
      library: Library project
  - id: types
    name: Type Checking
    type: enum
    description: How to handle type checking.
    default: ts
    options:
      ts: TypeScript syntax
      jsdoc: JSDoc comments
      null: None
  - id: prettier
    name: Add Prettier
    type: boolean
    description: Add Prettier for code formatting.
    default: true
  - id: eslint
    name: Add ESLint
    type: boolean
    description: Add ESLint for code linting.
    default: true
  - id: vitest
    name: Add Vitest
    type: boolean
    description: Add Vitest for unit testing.
    default: false
  - id: playwright
    name: Add Playwright
    type: boolean
    description: Add Playwright for browser testing.
    default: false
  - id: tailwindcss
    name: Add Tailwind CSS
    type: boolean
    description: Add Tailwind CSS for styling.
    default: false
  - id: drizzle
    name: Add Drizzle
    type: boolean
    description: Add Drizzle ORM for database access.
    default: false
  - id: lucia
    name: Add Lucia
    type: boolean
    description: Add Lucia for authentication.
    default: false
  - id: mdsvex
    name: Add MDsveX
    type: boolean
    description: Add MDsveX for using Markdown in Svelte.
    default: false
  - id: paraglide
    name: Add Paraglide
    type: boolean
    description: Add Paraglide for i18n.
    default: false
  - id: storybook
    name: Add Storybook
    type: boolean
    description: Add Storybook for component development.
    default: false
---

## When to Use This Skill

Use this skill to create a new, customized SvelteKit project. It allows for the selection of common tools and integrations from the start.

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project, run installer scripts from the `scripts` folder, and install dependencies.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Build and execute the `npm create svelte` command with the correct flags based on user inputs.
    - Copy `init.js` and `package.json` from the `templates/sveltekit` directory into the new project.
    - Execute the `init.js` script, passing the selected integrations as arguments. This script will run `npx svelte-add` for each tool and install all dependencies.
    - Create the `.agent/rules/sveltekit.md` file.

3.  **Final Verification**
    Check that the following files exist in the new project directory:
    - `package.json`
    - `init.js`
    - `svelte.config.js`
    - `.agent/rules/sveltekit.md`
