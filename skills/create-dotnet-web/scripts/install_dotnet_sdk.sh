#!/usr/bin/env bash
set -euo pipefail

# Installs the latest stable .NET SDK from the official script.
# - Checks for existing installation.
# - Downloads and runs the official dotnet-install.sh script.
# - Installs to a user-local directory (~/.dotnet).
# - Updates shell profile PATH (bash/zsh/profile).
# - Prompts for a restart.

MIN_DOTNET_VERSION="${MIN_DOTNET_VERSION:-8.0.0}"

need_cmd() { command -v "$1" >/dev/null 2>&1; }

ver_to_int() {
  local IFS=.
  # Pad with zeros for short versions
  read -r a b c <<< "${1:-0.0.0}.0.0"
  printf "%03d%03d%03d" "${a:-0}" "${b:-0}" "${c:-0}"
}

current_dotnet_version() {
  dotnet --version 2>/dev/null || echo ""
}

# Check if a sufficient version of .NET is already installed
if need_cmd dotnet; then
  CUR="$(current_dotnet_version)"
  if [[ -n "${CUR}" ]] && [[ "$(ver_to_int "${CUR}")" -ge "$(ver_to_int "${MIN_DOTNET_VERSION}")" ]]; then
    echo ".NET SDK is already installed: version ${CUR} (>= ${MIN_DOTNET_VERSION}). No action needed."
    exit 0
  fi
  echo ".NET SDK detected (version ${CUR:-unknown}) but < ${MIN_DOTNET_VERSION}; proceeding to install latest stable."
fi

DL_TOOL=""
if need_cmd curl; then DL_TOOL="curl -fsSL"
elif need_cmd wget; then DL_TOOL="wget -qO-"
else
  echo "Error: need curl or wget to download the installer." >&2
  exit 1
fi

# Download the installer script
TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

INSTALLER_SH="$TMP/dotnet-install.sh"
echo "Downloading .NET install script..."
$DL_TOOL https://dot.net/v1/dotnet-install.sh > "$INSTALLER_SH"
chmod +x "$INSTALLER_SH"

# Run the installer script. It installs to ~/.dotnet by default.
# We'll install the latest Long-Term Support (LTS) version.
echo "Running .NET installer..."
"$INSTALLER_SH" --channel LTS --install-dir "$HOME/.dotnet"

# --- Update Shell Profiles ---
DOTNET_ROOT="$HOME/.dotnet"
EXPORT_LINE="export PATH=\"$DOTNET_ROOT:\$PATH\"" # Shell-escaped for profile
MARKER="# >>> antigravity dotnet >>>"

write_profile() {
  local f="$1"
  echo "Updating profile: $f"
  [[ -f "$f" ]] || touch "$f"
  if ! grep -q "$MARKER" "$f"; then
    {
      echo ""
      echo "$MARKER"
      echo "export DOTNET_ROOT=\"$DOTNET_ROOT\"" # Also export DOTNET_ROOT
      echo "$EXPORT_LINE"
      echo "# <<< antigravity dotnet <<<"
    } >> "$f"
  fi
}

# Update common profiles
if [ -n "${BASH_VERSION:-}" ]; then
  write_profile "$HOME/.bashrc"
fi
if [ -n "${ZSH_VERSION:-}" ]; then
  write_profile "$HOME/.zshrc"
fi
write_profile "$HOME/.profile"

echo ""
echo "Installed .NET SDK into $DOTNET_ROOT"
echo "Restart your shell or Antigravity session, then verify with:"
echo "  dotnet --version"
