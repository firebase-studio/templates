# AI Rules for the PostgreSQL Project

## 1. Project Overview

This project provides a self-contained, reproducible PostgreSQL development environment using Nix. It is designed to be a ready-to-use database starter with a pre-defined schema and sample data.

The key characteristics are:

- **Automated Setup:** The environment is fully automated by the `.idx/dev.nix` file. It starts a PostgreSQL 16 server, creates a database, and initializes it.
- **Database Details:**
  - **Database Name:** `youtube`
  - **User:** `user`
  - **Password:** `mypassword`
- **Pre-configured Tools:** The environment includes the `sqltools` and `sqltools-driver-pg` VS Code extensions for immediate database interaction.

## 2. Key Files

When providing assistance, be aware of the following files:

- **`create.sql`**: Defines the database schema (tables, columns, etc.). This is the source of truth for the database structure.
- **`example.sql`**: Contains sample data that is inserted into the database after the schema is created. Useful for demonstrating queries.
- **`.idx/dev.nix`**: The core Nix file that defines the entire development environment, including services, packages, and startup scripts. Avoid suggesting manual installation of packages that can be managed here.

## 3. Development Environment

- **Nix-Managed:** The environment is controlled by Nix. Do not suggest using `apt`, `brew`, or other system-level package managers. Dependencies like `postgresql` are managed through the `dev.nix` file.
- **SQLTools:** The workspace is pre-configured with SQLTools. Encourage users to leverage this extension for running queries, browsing the schema, and managing the database directly from the IDE.
- **Connection String:** The `POSTGRESQL_CONN_STRING` environment variable is available for applications that need to connect to the database.

## 4. Interaction Guidelines

- Assume the user is familiar with SQL but may be new to this Nix-based, automated setup.
- When generating SQL queries, tailor them to the schema defined in `create.sql` (e.g., query the `videos` table).
- If a user wants to modify the database schema, guide them to edit the `create.sql` file. Remind them that for the changes to take effect in a new workspace, the setup script must be re-run (which happens automatically on creation). For an existing workspace, they may need to apply the changes manually using SQLTools.
- Proactively suggest using the integrated SQLTools for database interaction instead of external clients.
- If the user asks about connection details, refer them to the pre-set database name (`youtube`), user (`user`), and password (`mypassword`).
