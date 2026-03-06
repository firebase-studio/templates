#!/usr/bin/env bash
set -euo pipefail

# Installs the latest .NET 8 SDK from official releases (user-local install).
# - Checks if .NET 8+ is already installed.
# - Downloads official installer script.
# - Installs under ~/.dotnet_sdk
# - Updates shell profile PATH (bash/zsh/profile)
# - Prompts restart

need_cmd() { command -v "$1" >/dev/null 2>&1; }

# Check if dotnet is installed and version is >= 8
if need_cmd dotnet; then
  ver="$(dotnet --version)"
  major="${ver%%.*}"
  if [[ "$major" -ge 8 ]]; then
    echo ".NET SDK is already installed (version $ver). No action needed."
    exit 0
  fi
  echo ".NET SDK detected (version $ver) but < 8; proceeding to install latest .NET 8 SDK."
fi

DL_TOOL=""
if need_cmd curl; then DL_TOOL="curl -fsSL"
elif need_cmd wget; then DL_TOOL="wget -qO-"
else
  echo "Error: need curl or wget"
  exit 1
fi

INSTALL_DIR="${INSTALL_DIR:-$HOME/.dotnet_sdk}"
mkdir -p "$INSTALL_DIR"

INSTALL_SCRIPT_URL="https://dot.net/v1/dotnet-install.sh"
INSTALL_SCRIPT_PATH="$INSTALL_DIR/dotnet-install.sh"

echo "Downloading dotnet-install.sh to $INSTALL_SCRIPT_PATH"
$DL_TOOL "$INSTALL_SCRIPT_URL" > "$INSTALL_SCRIPT_PATH"
chmod +x "$INSTALL_SCRIPT_PATH"

echo "Installing .NET SDK to $INSTALL_DIR"
"$INSTALL_SCRIPT_PATH" --channel 8.0 --install-dir "$INSTALL_DIR" --no-path

DOTNET_BIN="$INSTALL_DIR"
EXPORT_LINE="export PATH=\"$DOTNET_BIN:\$PATH\""
MARKER="# >>> antigravity dotnet >>>"

write_profile() {
  local f="$1"
  [[ -f "$f" ]] || touch "$f"
  if ! grep -q "$MARKER" "$f"; then
    echo "Updating profile: $f"
    {
      echo ""
      echo "$MARKER"
      echo "$EXPORT_LINE"
      echo "# <<< antigravity dotnet <<<"
    } >> "$f"
  else
    echo "Profile already updated: $f"
  fi
}

# Update common profiles
if [[ -n "${BASH_VERSION:-}" ]]; then
  write_profile "$HOME/.bashrc"
fi
if [[ -n "${ZSH_VERSION:-}" ]]; then
  write_profile "$HOME/.zshrc"
fi
write_profile "$HOME/.profile"

echo ""
echo "Installed .NET 8 SDK under $INSTALL_DIR"
echo "Restart your shell / Antigravity session, then verify:"
echo "  dotnet --version"
