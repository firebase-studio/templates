#!/usr/bin/env bash
set -euo pipefail

# Installs the specified backend (Node.js or Go) for HTMX development.
# - Detects OS + CPU arch
# - Fetches the latest version
# - Downloads the official tarball
# - Installs under ~/.local/
# - Updates shell profile PATH
# - Prompts for a terminal restart

# --- Helper Functions ---

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# --- Installation Functions ---

install_node() {
  echo "Setting up Node.js for HTMX..."

  if need_cmd node; then
    ver="$(node -v)"
    major="${ver#v}"; major="${major%%.*}"
    if [[ "$major" -ge 18 ]]; then
      echo "Node.js >=18 is already installed ($ver). No action needed."
      npm -v || true
      exit 0
    fi
    echo "An older version of Node.js was detected ($ver); proceeding to install the required LTS version."
  fi

  DL_TOOL=""
  if need_cmd curl; then DL_TOOL="curl -fsSL"; elif need_cmd wget; then DL_TOOL="wget -qO-"; else
    echo "Error: need curl or wget"; exit 1
  fi

  OS_TAG="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH_TAG="$(uname -m)"
  case "$ARCH_TAG" in
    x86_64|amd64) ARCH_TAG="x64" ;;
    arm64|aarch64) ARCH_TAG="arm64" ;;
  esac

  INDEX_JSON="$($DL_TOOL https://nodejs.org/dist/index.json)"
  VERSION="$(echo "$INDEX_JSON" | jq -r '.[] | select(.lts != false) | .version' | head -n 1)"

  if [[ -z "${VERSION:-}" ]]; then echo "Error: could not determine latest LTS version"; exit 1; fi

  EXT="tar.xz" && [[ "$OS_TAG" == "darwin" ]] && EXT="tar.gz"
  TARBALL="node-${VERSION}-${OS_TAG}-${ARCH_TAG}.${EXT}"
  URL="https://nodejs.org/dist/${VERSION}/${TARBALL}"

  INSTALL_BASE="${HOME}/.local/node"
  INSTALL_DIR="${INSTALL_BASE}/${VERSION}"
  mkdir -p "$INSTALL_BASE"

  TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
  echo "Downloading Node.js LTS for HTMX: $URL"
  $DL_TOOL "$URL" -o "$TMP/$TARBALL"

  echo "Installing to $INSTALL_DIR"
  rm -rf "$INSTALL_DIR" && mkdir -p "$INSTALL_DIR"
  tar -xf "$TMP/$TARBALL" -C "$INSTALL_DIR" --strip-components=1

  ln -sfn "$INSTALL_DIR" "${INSTALL_BASE}/current"
  
  BIN_PATH="$INSTALL_BASE/current/bin"
  MARKER="# >>> IDX Node for HTMX >>>"
  update_shell_profiles "$BIN_PATH" "$MARKER"

  echo ""
  echo "Successfully installed Node.js ${VERSION} for HTMX."
  echo "Please restart your shell/terminal, then verify the installation:"
  echo "  node -v"
  echo "  npm -v"
}

install_go() {
  echo "Setting up Go for HTMX..."

  if need_cmd go; then
    echo "Go is already installed. No action needed."
    go version
    exit 0
  fi

  DL_TOOL=""
  if need_cmd curl; then DL_TOOL="curl -fsSL"; elif need_cmd wget; then DL_TOOL="wget -qO-"; else
    echo "Error: need curl or wget"; exit 1
  fi

  OS_TAG="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH_TAG="$(uname -m)"
  case "$ARCH_TAG" in
    x86_64|amd64) ARCH_TAG="amd64" ;; # Go uses 'amd64'
    arm64|aarch64) ARCH_TAG="arm64" ;;
  esac

  GO_JSON="$($DL_TOOL 'https://go.dev/dl/?mode=json')"
  GO_FILE_INFO="$(echo "$GO_JSON" | jq -r --arg os "$OS_TAG" --arg arch "$ARCH_TAG" '.[0].files[] | select(.os==$os and .arch==$arch and .kind=="archive")')"
  
  if [[ -z "$GO_FILE_INFO" ]]; then echo "Error: Could not find a Go release for your platform ($OS_TAG/$ARCH_TAG)."; exit 1; fi

  GO_TARBALL="$(echo "$GO_FILE_INFO" | jq -r '.filename')"
  GO_VERSION="$(echo "$GO_FILE_INFO" | jq -r '.version')" # Extracts 'go1.x.y'
  URL="https://go.dev/dl/${GO_TARBALL}"

  INSTALL_BASE="${HOME}/.local"
  INSTALL_DIR="${INSTALL_BASE}/go"
  mkdir -p "$INSTALL_BASE"

  TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
  echo "Downloading Go for HTMX: $URL"
  $DL_TOOL "$URL" -o "$TMP/$GO_TARBALL"

  echo "Installing to $INSTALL_DIR"
  rm -rf "$INSTALL_DIR" # Remove old installation
  tar -C "$INSTALL_BASE" -xzf "$TMP/$GO_TARBALL"

  BIN_PATH="$INSTALL_DIR/bin"
  MARKER="# >>> IDX Go for HTMX >>>"
  update_shell_profiles "$BIN_PATH" "$MARKER"
  
  echo ""
  echo "Successfully installed ${GO_VERSION} for HTMX."
  echo "Please restart your shell/terminal, then verify the installation:"
  echo "  go version"
}

update_shell_profiles() {
  local bin_path="$1"
  local marker="$2"
  local export_line="export PATH=\"$bin_path:\$PATH\""

  write_profile() {
    local f="$1"
    [[ -f "$f" ]] || touch "$f"
    if ! grep -qF "$marker" "$f"; then
      printf "\\n%s\\n%s\\n%s\\n" "$marker" "$export_line" "${marker///>/</}" >> "$f"
      echo "Updated $f"
    fi
  }

  echo "Updating shell profiles to include $bin_path in PATH..."
  write_profile "$HOME/.profile"
  write_profile "$HOME/.bashrc"
  write_profile "$HOME/.zshrc"
}


# --- Main Logic ---

BACKEND="${1:-go}"

case "$BACKEND" in
  node) install_node ;;
  go)   install_go ;;
  *)
    echo "Error: Invalid backend '$BACKEND'. Choose 'node' or 'go'."
    exit 1
    ;;
esac
