#!/usr/bin/env bash
set -euo pipefail

# Installs latest Node.js LTS from official nodejs.org releases (user-local install).
# - Detects OS + CPU arch
# - Fetches latest LTS from Node dist index.json
# - Downloads official tarball and installs under ~/.local/node/current
# - Updates shell profile PATH (bash/zsh/profile)
# - Prompts restart

need_cmd() { command -v "$1" >/dev/null 2>&1; }

if need_cmd node; then
  ver="$(node -v)"
  major="${ver#v}"; major="${major%%.*}"
  if [[ "$major" -ge 20 ]]; then
    echo "Node is already installed ($ver). No action needed."
    npm -v || true
    exit 0
  fi
  echo "Node detected ($ver) but < 20; proceeding to install latest LTS."
fi

DL_TOOL=""
if need_cmd curl; then DL_TOOL="curl -fsSL"
elif need_cmd wget; then DL_TOOL="wget -qO-"
else
  echo "Error: need curl or wget"
  exit 1
fi

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin) OS_TAG="darwin" ;;
  Linux)  OS_TAG="linux" ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64|amd64) ARCH_TAG="x64" ;;
  arm64|aarch64) ARCH_TAG="arm64" ;;
  armv7l) ARCH_TAG="armv7l" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

INDEX_JSON="$($DL_TOOL https://nodejs.org/dist/index.json)"

# Parse latest LTS version:
if need_cmd jq; then
  VERSION="$(printf '%s' "$INDEX_JSON" | jq -r '.[] | select(.lts != false) | .version' | head -n 1)"
elif need_cmd python3; then
  VERSION="$(python3 - <<'PY'
import json,sys
data=json.load(sys.stdin)
for r in data:
    if r.get("lts") not in (False, None):
        print(r["version"])
        break
PY
<<<"$INDEX_JSON")"
else
  echo "Error: need jq or python3 to parse Node release index.json"
  exit 1
fi

if [[ -z "${VERSION:-}" || "${VERSION}" == "null" ]]; then
  echo "Error: could not determine latest LTS version"
  exit 1
fi

PLATFORM="${OS_TAG}-${ARCH_TAG}"

# Node uses .tar.gz for macOS builds, and .tar.xz for Linux builds.
EXT="tar.xz"
[[ "$OS_TAG" == "darwin" ]] && EXT="tar.gz"

TARBALL="node-${VERSION}-${PLATFORM}.${EXT}"
URL="https://nodejs.org/dist/${VERSION}/${TARBALL}"

INSTALL_BASE="${INSTALL_BASE:-$HOME/.local/node}"
INSTALL_DIR="${INSTALL_BASE}/${VERSION}"

mkdir -p "$INSTALL_BASE"

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Downloading $URL"
if need_cmd curl; then
  curl -fsSL "$URL" -o "$TMP/$TARBALL"
else
  wget -q "$URL" -O "$TMP/$TARBALL"
fi

echo "Installing to $INSTALL_DIR"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

if [[ "$EXT" == "tar.gz" ]]; then
  tar -xzf "$TMP/$TARBALL" -C "$TMP"
elif [[ "$EXT" == "tar.xz" ]]; then
  tar -xJf "$TMP/$TARBALL" -C "$TMP"
else
    echo "Unsupported archive format: $EXT"
    exit 1
fi

EXTRACTED="$TMP/node-${VERSION}-${PLATFORM}"
if [[ ! -d "$EXTRACTED" ]]; then
  echo "Error: expected extracted folder not found: $EXTRACTED"
  exit 1
fi

# Move contents into versioned install dir
cp -R "$EXTRACTED"/. "$INSTALL_DIR"/

# Update 'current' symlink
ln -sfn "$INSTALL_DIR" "$INSTALL_BASE/current"

NODE_BIN="$INSTALL_BASE/current/bin"
EXPORT_LINE="export PATH=\"$NODE_BIN:\$PATH\""
MARKER="# >>> antigravity node >>>"

write_profile() {
  local f="$1"
  [[ -f "$f" ]] || touch "$f"
  if ! grep -q "$MARKER" "$f"; then
    {
      echo ""
      echo "$MARKER"
      echo "$EXPORT_LINE"
      echo "# <<< antigravity node <<<"
    } >> "$f"
  fi
}

# Update common profiles
write_profile "$HOME/.bashrc"
write_profile "$HOME/.zshrc"
write_profile "$HOME/.profile"

echo ""
echo "Installed Node ${VERSION} under $INSTALL_BASE/current"
echo "Restart your shell / Antigravity session, then verify:"
echo "  node -v"
echo "  npm -v"