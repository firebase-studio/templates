# Postgres Workspace Setup Instructions

This skill automates the entire setup of a new PostgreSQL database environment. There are no manual installation steps required.

---

## 1. Create the Database Project

When you run this skill, you will be prompted for a `Project Name`. This name will be used to create a new directory for your database project.

The skill will then automatically perform the following actions:

- **Scaffold the Project:** It copies a pre-configured set of files into your new project directory.
- **Configure the Environment:** A file at `.idx/dev.nix` is included, which tells IDX to automatically:
  - Start a PostgreSQL 16 server.
  - Create a database named `youtube`.
  - Create a user named `user` with the password `mypassword`.
  - Initialize the database schema by running `create.sql`.
  - Populate the database with sample data by running `example.sql`.
- **Set Environment Variables:** It configures the `POSTGRESQL_CONN_STRING` environment variable so you can connect to your database instantly.

---

## 2. Using Your Database

Once the skill is finished, your PostgreSQL database is ready to use immediately. 

No further setup is required. You can connect to the database using the provided connection string or use the integrated SQLTools within the IDE.
