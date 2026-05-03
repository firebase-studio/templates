# Dart Workspace Setup Instructions

Follow these steps to initialize the workspace.

## 1. Install prerequisites (Dart SDK)

This skill requires the Dart SDK.

### 1.1 Download and Unzip the SDK

If the Dart SDK is not installed, you can download and unzip it.

```bash
unzip -o dartsdk-linux-x64-release.zip -d my-dart-sdk
```

**Output:**
```
Archive:  dartsdk-linux-x64-release.zip
  inflating: my-dart-sdk/dart-sdk/dartdoc_options.yaml
...
  inflating: my-dart-sdk/dart-sdk/include/internal/dart_api_dl_impl.h
```

### 1.2 Add Dart to PATH and Verify

```bash
export PATH="$PATH:/home/user/angulartest/my-dart-sdk/dart-sdk/bin" && dart --version
```

**Output:**
```
Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "linux_x64"
```

---

## 2. Create the project

Scaffold the Dart application.

```bash
export PATH="$PATH:/home/user/angulartest/my-dart-sdk/dart-sdk/bin" && dart create -t server-shelf "my-dart-app"
```

**Output:**
```
Creating my_dart_app using template server-shelf...

  .gitignore
  analysis_options.yaml
  CHANGELOG.md
  pubspec.yaml
  README.md
  Dockerfile
  .dockerignore
  test/server_test.dart
  bin/server.dart

Running pub get...
  Resolving dependencies...
  Changed 51 dependencies!
  31 packages have newer versions incompatible with dependency constraints.
  Try `dart pub outdated` for more information.

Created project my_dart_app in my-dart-app! In order to get started, run the following commands:

  cd my-dart-app
  dart run bin/server.dart
```

### 2.1 Copy watcher utility

Copy the `watcher.dart` utility from the skill resources to your new project's `bin` directory.

```bash
cp -R "skills/create-dart/assets/watcher.dart" "my-dart-app/bin/"
```

Then enter the workspace:

```bash
cd "my-dart-app"
```

## 3. Install dependencies

cd into the new project directory and run `dart pub get`:

```bash
cd my-dart-app && export PATH="$PATH:/home/user/angulartest/my-dart-sdk/dart-sdk/bin" && dart pub get
```

**Output:**
```
Resolving dependencies...
  _fe_analyzer_shared 67.0.0 (97.0.0 available)
  analyzer 6.4.1 (11.0.0 available)
...
Got dependencies!
31 packages have newer versions incompatible with dependency constraints.
Try `dart pub outdated` for more information.
```

## 4. Configure Agents Rules

Create `.agents/rules/dart.md` inside the new workspace directory and copy the content from `skills/create-dart/resources/ai_rules.md`.

## 5. Run server

Run the server. If port 8080 is in use, you can specify a different port.

```bash
cd my-dart-app && export PATH="$PATH:/home/user/angulartest/my-dart-sdk/dart-sdk/bin" && dart run bin/server.dart --port=8081
```

**Expected Output:**
```
Server listening on port 8081
```
