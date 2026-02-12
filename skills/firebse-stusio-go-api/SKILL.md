---
name: firebase-studio-go-api
description: Scaffold a new project from firebase-studio/templates go/api and run it locally (best-effort; not 1:1 with Firebase Studio previews).
license: Apache-2.0
---

## What this does
This skill creates a new project directory using the Firebase Studio Go API template located at `go/api/` in the `firebase-studio/templates` repository.

## Create a new project (Windows PowerShell)
From the repo root:
- `pwsh -ExecutionPolicy Bypass -File ./skills/firebase-studio-go-api/scripts/scaffold.ps1 -Dest <path-to-new-project>`

Example:
- `pwsh -ExecutionPolicy Bypass -File ./skills/firebase-studio-go-api/scripts/scaffold.ps1 -Dest ../demo-go-api`

## Run locally (best-effort)
After scaffolding:
1. `cd <new-project>`
2. `go test ./...`
3. `go run .`

## Notes / limitations
- Firebase Studio/IDX previews and port UI are not reproduced locally.
- The `.idx/` folder is copied as-is (useful as a reference of expected tooling).
