name: create-java
description: Creates a new, runnable Java Spring Boot application that serves a "Hello world" message.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder and artifactId for the new project.

---

## When to Use This Skill

Use this skill when the user wants to create a new "Hello world" Java Spring Boot application. The skill scaffolds the project using Spring Initializr, installs custom AI rules, and then adds a REST controller to serve a "Hello world" message from the root endpoint (`/`).

## Instructions

1.  **Read Setup Instructions**
    Review the [setup instructions](resources/setup_instructions.md) to understand how to initialize the project and install dependencies.

    *Action:* Read `resources/setup_instructions.md`.

2.  **Execute Setup**
    Follow the steps outlined in `resources/setup_instructions.md` to:
    - Install prerequisites (Java + Maven).
    - Create the Spring Boot project (using the `workspace_name` input).
    - Configure the `.agent/rules/java.md` file.
      - Ensure the `.agent/rules/` directory exists.

3.  **Implement "Hello World" Endpoint**
    *Goal:* The application needs to serve a "Hello world" message.
    *Action:* Using your expertise as a Java Spring Boot developer, create a REST controller that responds with the string "Hello world" when a request is made to the root path (`/`). Place this controller in the appropriate package within the project's source directory, ensuring the package name is correct based on the project's artifactId.

4.  **Final Verification**
    Check that:
    - `pom.xml` exists in the new project.
    - `.agent/rules/java.md` exists.
    - The source code for the "Hello World" REST controller exists and is correctly placed.
