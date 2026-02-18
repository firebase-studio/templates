---
name: nextjs_ts
description: The React Framework for the Web, with support for TypeScript and JavaScript.
platforms:
  - "mac"
  - "linux"
  - "windows"
prerequisites:
  - name: node
    version: ">=20.0.0"
    install_instruction: "Install Node.js 20 from https://nodejs.org/ or use `pkgs.nodejs_20` in .idx/dev.nix."
params:
  - id: language
    name: Language
    type: enum
    default: "ts"
    options:
      js: "JavaScript"
      ts: "TypeScript"
    required: true
  - id: packageManager
    name: "Package Manager"
    type: enum
    default: "npm"
    options:
      npm: "npm"
      yarn: "yarn"
      pnpm: "pnpm"
      bun: "bun"
    required: true
  - id: srcDir
    name: "Use a src/ dir"
    type: boolean
    default: true
    required: false
  - id: eslint
    name: "Use eslint"
    type: boolean
    default: true
    required: false
  - id: app
    name: "Use App Router"
    type: boolean
    default: true
    required: false
  - id: tailwind
    name: "Use Tailwind"
    type: boolean
    default: true
    required: false
  - id: importAlias
    name: "Import Alias"
    type: string
    default: "@/*"
    required: false
bootstrap:
  command: "npx --yes create-next-app@latest <project-name>"
---

# Skill: Next.js (JavaScript/TypeScript)

This skill bootstraps a new Next.js project. It allows you to configure the project with several options, including language (TypeScript or JavaScript), directory structure, and tooling.

An automated agent will prompt you to select values for the parameters defined in the frontmatter of this file.

## Bootstrap Command

The agent will use your selections and the base command defined in the `bootstrap` section to construct and execute the appropriate `create-next-app` command with the necessary flags.

### Example

A command to create a TypeScript project with a `src` directory and Tailwind CSS would look like this:

```bash
npx --yes create-next-app@latest <project-name> --typescript --src-dir --tailwind
```
