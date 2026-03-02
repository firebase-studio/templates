#!/usr/bin/env bash
set -euo pipefail

# Installs the latest stable Go from official go.dev downloads (user-local install).
# - Detects OS + CPU arch
# - Fetches latest stable from https://go.dev/dl/?mode=json
# - Downloads official tarball
# - Installs under ~/.local/go/<version> and updates ~/.local/go/current symlink
# - Updates shell profile PATH (bash/zsh/profile)
# - Prompts restart

MIN_GO_VERSION="${MIN_GO_VERSION:-1.20.0}"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

ver_to_int() {
  local IFS=.
  read -r a b c <<< "${1:-0.0.0}"
  printf "%03d%03d%03d" "${a:-0}" "${b:-0}" "${c:-0}"
}

current_go_version() {
  # output: go version go1.22.5 linux/amd64
  go version | awk '{print $3}' | sed 's/^go//'
}

if need_cmd go; then
  CUR="$(current_go_version || true)"
  if [[ -n "${CUR}" ]] && [[ "$(ver_to_int "${CUR}")" -ge "$(ver_to_int "${MIN_GO_VERSION}")" ]]; then
    echo "Go is already installed: go${CUR} (>= ${MIN_GO_VERSION}). No action needed."
    exit 0
  fi
  echo "Go detected (go${CUR:-unknown}) but < ${MIN_GO_VERSION}; proceeding to install latest stable."
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
  x86_64|amd64) ARCH_TAG="amd64" ;;
  arm64|aarch64) ARCH_TAG="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

INDEX_JSON="$($DL_TOOL https://go.dev/dl/?mode=json)"

# Parse latest stable go version and find matching file for our OS/arch.
# We prefer .tar.gz for both linux/darwin (Go provides tar.gz for these).
if need_cmd jq; then
  VERSION_TAG="$(printf '%s' "$INDEX_JSON" | jq -r '.[] | select(.stable == true) | .version' | head -n 1)"
  FILE_NAME="$(printf '%s' "$INDEX_JSON" | jq -r --arg os "$OS_TAG" --arg arch "$ARCH_TAG" '
    .[] | select(.stable == true) | .files[] |
    select(.os == $os and .arch == $arch and .kind == "archive" and (.filename | endswith(".tar.gz"))) |
    .filename' | head -n 1)"
elif need_cmd python3; then
  read -r VERSION_TAG FILE_NAME < <(python3 - <<'PY'
import json,sys
data=json.load(sys.stdin)
stable=None
for r in data:
    if r.get("stable") is True:
        stable=r
        break
if not stable:
    print("", "")
    sys.exit(0)

version=stable.get("version","")
os_tag=sys.argv[1]
arch_tag=sys.argv[2]
fname=""
for f in stable.get("files",[]):
    if f.get("os")==os_tag and f.get("arch")==arch_tag and f.get("kind")=="archive":
        fn=f.get("filename","")
        if fn.endswith(".tar.gz"):
            fname=fn
            break
print(version, fname)
PY
<<<"$INDEX_JSON" "$OS_TAG" "$ARCH_TAG")
else
  echo "Error: need jq or python3 to parse Go release metadata"
  exit 1
fi

if [[ -z "${VERSION_TAG:-}" || "${VERSION_TAG}" == "null" ]]; then
  echo "Error: could not determine latest stable Go version"
  exit 1
fi

if [[ -z "${FILE_NAME:-}" || "${FILE_NAME}" == "null" ]]; then
  echo "Error: could not find matching Go archive for ${OS_TAG}/${ARCH_TAG}"
  exit 1
fi

# VERSION_TAG is like "go1.22.5" -> "1.22.5"
VERSION="${VERSION_TAG#go}"

URL="https://go.dev/dl/${FILE_NAME}"

INSTALL_BASE="${INSTALL_BASE:-$HOME/.local/go}"
INSTALL_DIR="${INSTALL_BASE}/${VERSION}"

mkdir -p "$INSTALL_BASE"

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "Downloading $URL"
if need_cmd curl; then
  curl -fsSL "$URL" -o "$TMP/$FILE_NAME"
else
  wget -q "$URL" -O "$TMP/$FILE_NAME"
fi

echo "Installing to $INSTALL_DIR"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

tar -xzf "$TMP/$FILE_NAME" -C "$TMP"

EXTRACTED="$TMP/go"
if [[ ! -d "$EXTRACTED" ]]; then
  echo "Error: expected extracted folder not found: $EXTRACTED"
  exit 1
fi

# Move extracted Go tree into versioned install dir
cp -R "$EXTRACTED"/. "$INSTALL_DIR"/

# Update 'current' symlink
ln -sfn "$INSTALL_DIR" "$INSTALL_BASE/current"

GO_BIN="$INSTALL_BASE/current/bin"
EXPORT_LINE="export PATH=\"$GO_BIN:\$PATH\""
MARKER="# >>> antigravity go >>>"

write_profile() {
  local f="$1"
  [[ -f "$f" ]] || touch "$f"
  if ! grep -q "$MARKER" "$f"; then
    {
      echo ""
      echo "$MARKER"
      echo "$EXPORT_LINE"
      echo "# <<< antigravity go <<<"
    } >> "$f"
  fi
}

# Update common profiles
write_profile "$HOME/.bashrc"
write_profile "$HOME/.zshrc"
write_profile "$HOME/.profile"

echo ""
echo "Installed Go ${VERSION_TAG} under $INSTALL_BASE/current"
echo "Restart your shell / Antigravity session, then verify:"
echo "  go version"