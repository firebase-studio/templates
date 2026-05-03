#!/bin/bash
# Installs the latest Node.js LTS from official nodejs.org releases (user-local install).
# - Detects CPU architecture
# - Fetches latest LTS from Node dist index.json
# - Downloads the official tar.gz
# - Extracts to ~/.local/share/nodejs/<version>
# - Adds to user PATH (no sudo required) in .bashrc / .zshrc / .profile
# - Prompts to restart terminal / Antigravity

set -euo pipefail

get_latest_lts_version() {
  local url="https://nodejs.org/dist/index.json"
  local lts_version=$(curl -s "$url" | grep '"lts"' | head -n 1 | sed -E 's/.*"version": "([^"]+)".*/\1/')
  if [[ -z "$lts_version" ]]; then
    echo "Error: Could not determine latest LTS from $url" >&2
    exit 1
  fi
  echo "$lts_version"
}

get_platform_suffix() {
  local arch=$(uname -m)
  case "$arch" in
    x86_64) echo "linux-x64" ;;
    aarch64) echo "linux-arm64" ;;
    *) echo "Error: Unsupported Linux architecture: $arch" >&2; exit 1 ;;
  esac
}

get_major_version() {
  local v=$1
  v=${v#v}
  echo "${v%%.*}"
}

# If Node already installed and >= 20, do nothing.
if command -v node &>/dev/null; then
  existing=$(node -v)
  major=$(get_major_version "$existing")
  if [[ "$major" -ge 20 ]]; then
    echo "Node is already installed ($existing). No action needed."
    echo -n "npm version: "; npm -v
    exit 0
  fi
  echo "Node detected ($existing) but < 20; proceeding to install latest LTS."
fi

VERSION=$(get_latest_lts_version)
PLATFORM=$(get_platform_suffix)
TAR_NAME="node-$VERSION-$PLATFORM.tar.gz"
TAR_URL="https://nodejs.org/dist/$VERSION/$TAR_NAME"

INSTALL_BASE="$HOME/.local/share/nodejs"
mkdir -p "$INSTALL_BASE"

TMP_DIR=$(mktemp -d)

cleanup() {
  if [[ -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

cd "$TMP_DIR"

echo "Downloading $TAR_URL"
wget -q "$TAR_URL"

echo "Extracting to $INSTALL_BASE"
tar -xzf "$TAR_NAME" -C "$INSTALL_BASE"

EXTRACTED_DIR="$INSTALL_BASE/node-$VERSION-$PLATFORM"
if [[ ! -d "$EXTRACTED_DIR" ]]; then
  echo "Extraction failed; expected folder not found: $EXTRACTED_DIR" >&2
  exit 1
fi

add_to_path() {
  local file=$1
  if [[ -f "$file" ]] || [[ -L "$file" ]]; then
    if ! grep -q "$EXTRACTED_DIR/bin" "$file"; then
      echo "Adding Node to PATH in $file"
      echo '' >> "$file"
      echo "# Add Node.js to PATH" >> "$file"
      echo "export PATH=\"$EXTRACTED_DIR/bin:\$PATH\"" >> "$file"
    fi
  fi
}

add_to_path "$HOME/.bashrc"
add_to_path "$HOME/.zshrc"
add_to_path "$HOME/.profile"

# Also update current session PATH
export PATH="$EXTRACTED_DIR/bin:$PATH"

echo "Installed Node $VERSION"
echo "Verify:"
node -v
npm -v

echo ""
echo "Restart your terminal / Antigravity session so PATH updates fully."
