---
name: next
version: 0.1.0
description: A skill for creating a Next.js project.
---
# Skill: Next.js

This document provides all the necessary information for an automated agent to bootstrap a new Next.js project.

## Platforms
- **OS:**
  - `darwin` # macOS
  - `linux`

## Prerequisites

### Runtime Environment
- **Tool:** Node.js
- **Version:** ">=20.0.0"

### Package Managers
The agent must have at least one of the following package managers available:
- **Tool:** npm
- **Version:** ">=10.0.0"
- **Tool:** yarn
- **Version:** ">=1.22.0"
- **Tool:** pnpm
- **Version:** ">=8.0.0"
- **Tool:** bun
- **Version:** ">=1.0.0"

### SDKs
- **SDK:** Next.js
- **Version:** The version will be determined by `create-next-app@latest`.
- **SDK:** React
- **Version:** The version will be determined by the Next.js version installed.

## Installation Steps

1.  **Create a new Next.js app:**
    ```bash
    npx create-next-app@latest my-next-app
    ```

2.  **Navigate to your project directory:**
    ```bash
    cd my-next-app
    ```

## Resources
The `resources/` directory contains boilerplate files that should be copied into the root of the newly created project after the installation steps are complete.
