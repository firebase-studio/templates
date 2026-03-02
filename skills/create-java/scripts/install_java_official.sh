#!/usr/bin/env bash
set -euo pipefail

# Installs Java (OpenJDK 17) and Maven using SDKMAN!

need_cmd() { command -v "$1" >/dev/null 2>&1; }

# Check for Java
java_ok=false
if need_cmd java; then
  ver="$(java -version 2>&1 | head -n 1)"
  if [[ "$ver" == *'version "17.'* ]]; then
    echo "Java 17 is already installed ($ver)."
    java_ok=true
  else
    echo "An unsupported version of Java is installed ($ver). Proceeding with installation of version 17."
  fi
elif [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    if need_cmd java; then
        ver="$(java -version 2>&1 | head -n 1)"
        if [[ "$ver" == *'version "17.'* ]]; then
            echo "Java 17 is already installed ($ver)."
            java_ok=true
        fi
    fi
fi

# Check for Maven
maven_ok=false
if need_cmd mvn; then
  ver="$(mvn -v 2>&1 | head -n 1)"
  echo "Maven is already installed ($ver)."
  maven_ok=true
elif [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    if need_cmd mvn; then
        ver="$(mvn -v 2>&1 | head -n 1)"
        echo "Maven is already installed ($ver)."
        maven_ok=true
    fi
fi

if $java_ok && $maven_ok; then
  echo "Java and Maven are already installed. No action needed."
  exit 0
fi

# Install SDKMAN! if not installed
if [[ ! -d "$HOME/.sdkman" ]]; then
  echo "Installing SDKMAN!"
  curl -s "https://get.sdkman.io" | bash
fi

source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install Java if not installed
if ! $java_ok; then
  echo "Installing Java 17..."
  sdk install java 17.0.10-tem
fi

# Install Maven if not installed
if ! $maven_ok; then
  echo "Installing Maven..."
  sdk install maven
fi

echo ""
echo "Java and Maven installation complete."
echo "Please restart your shell / Antigravity session, then verify:"
echo "  java -version"
echo "  mvn -v"
