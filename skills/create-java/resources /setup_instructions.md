# Setup Instructions for Java Demo Application

This document provides instructions on how to set up and run the Java demo application.

## 1. Prerequisites

- Java 17 or higher
- Maven 3.6 or higher

## 2. Dependencies

The project dependencies are managed by Maven and are listed in the `pom.xml` file. The main dependencies are:

- `spring-boot-starter-web`: For building web applications.
- `spring-boot-devtools`: For automatic restarts and live reloading.
- `spring-boot-starter-test`: For testing the application.

To install the dependencies, run the following command in the root directory of the project:

```bash
mvn install
```

## 3. Running the Application

To run the application, use the following Maven command:

```bash
mvn spring-boot:run
```

The application will start on port 8080 by default. You can access it at `http://localhost:8080`.

### Configuration

You can customize the greeting message by setting the `NAME` environment variable. For example:

```bash
export NAME="YourName"
mvn spring-boot:run
```

## 4. Testing the Application

To run the tests, use the following Maven command:

```bash
mvn test
```
