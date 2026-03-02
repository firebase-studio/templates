# Java Spring Boot Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Java + Maven)

This skill requires:
- Java Development Kit (JDK) (recommended 17.x+)
- Apache Maven

### 1.1 Verify
Run:
- `java -version`
- `mvn -v`

If both work, go to **Step 2**.

### 1.2 Install automatically
Use the provided prereq installer script that uses SDKMAN! for Linux/macOS and Chocolatey for Windows.

Run ONE of the following depending on your OS:

#### Windows (PowerShell)
Run:
- `powershell -ExecutionPolicy Bypass -File "scripts/install_java_official.ps1"`

Then restart your terminal / Antigravity session and verify:
- `java -version`
- `mvn -v`

#### macOS / Linux (bash)
Run:
- `bash "scripts/install_java_official.sh"`

Then restart your shell and verify:
- `java -version`
- `mvn -v`

> Note: These scripts may require administrator/sudo privileges.

---

## 2. Create the project

Set the workspace name:
- `WS_NAME="<workspace_name>"`

Then scaffold the Spring Boot project using the Spring Initializr API:

```bash
curl https://start.spring.io/starter.zip \
  -d type=maven-project \
  -d dependencies=web,devtools \
  -d javaVersion=17 \
  -d groupId=com.example \
  -d artifactId="$WS_NAME" \
  -d name="$WS_NAME" \
  -d description="Demo project for Spring Boot" \
  -o "${WS_NAME}.zip"

unzip "${WS_NAME}.zip" -d . # unzips into a folder named after WS_NAME
rm "${WS_NAME}.zip"
```

This command creates a new Spring Boot application with `spring-boot-starter-web` and `spring-boot-devtools`.

## 3. Configure Agent Rules

Move into the new project directory:
`cd "$WS_NAME"`

Create the agent rules directory:
`mkdir -p .agent/rules/`

Copy the AI rules:
`cp ../resources/ai_rules.md .agent/rules/java.md`

## 4. Run the server

Once inside the project directory, run the application:
`mvn spring-boot:run`

The application will be available at `http://localhost:8080`.
