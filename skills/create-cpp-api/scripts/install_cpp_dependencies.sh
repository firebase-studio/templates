#!/usr/bin/env bash
set -euo pipefail

# This script verifies that Docker and Docker Compose are installed,
# as they are required to build and run this project.
# It does NOT install them automatically, as Docker installation is
# platform-specific and requires user intervention.

echo "Checking for Docker..."

if ! command -v docker &> /dev/null; then
    echo "Error: 'docker' command not found."
    echo "Docker is required to build and run this C++ project."
    echo "Please install Docker for your system by following the official instructions:"
    echo "- macOS: https://docs.docker.com/desktop/install/mac-install/"
    echo "- Linux: https://docs.docker.com/engine/install/"
    echo "After installation, please restart your terminal and try again."
    exit 1
fi

echo "Docker found: $(docker --version)"

echo "Checking for Docker Compose..."

# Check for both 'docker-compose' (v1) and 'docker compose' (v2)
if command -v docker-compose &> /dev/null; then
    echo "Docker Compose (v1) found: $(docker-compose --version)"
elif docker compose version &> /dev/null; then
    echo "Docker Compose (v2) found: $(docker compose version)"
else
    echo "Error: 'docker-compose' or 'docker compose' command not found."
    echo "Docker Compose is required to run the application."
    echo "It is typically included with Docker Desktop. If you are on Linux, you may need to install it separately."
    echo "See: https://docs.docker.com/compose/install/"
    echo "After installation, please restart your terminal and try again."
    exit 1
fi

echo "All required dependencies (Docker, Docker Compose) are present."
exit 0
