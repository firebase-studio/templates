#!/usr/bin/env bash
# =============================================================================
# Gemini Skill – install_prerequisites.sh
# Usage: bash install_prerequisites.sh <stack>
# Stacks: js-web | js-web-genkit | py-web | py-notebook | go-web
# =============================================================================

set -euo pipefail

STACK="${1:-}"

if [[ -z "$STACK" ]]; then
  echo "Usage: $0 <stack>"
  echo "  stack: js-web | js-web-genkit | py-web | py-notebook | go-web"
  exit 1
fi

# ─── Helpers ──────────────────────────────────────────────────────────────────

detect_os() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  elif command -v apt-get &>/dev/null; then
    echo "debian"
  elif command -v dnf &>/dev/null; then
    echo "fedora"
  elif command -v yum &>/dev/null; then
    echo "rhel"
  else
    echo "unknown"
  fi
}

OS="$(detect_os)"

# Add a line to shell profiles (zshrc + bashrc) if not already present
add_to_path_profiles() {
  local line="$1"
  local profiles=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile")
  for profile in "${profiles[@]}"; do
    if [[ -f "$profile" ]] && grep -qF "$line" "$profile"; then
      echo "  ↳ Already in $profile – skipping"
    else
      echo "$line" >> "$profile"
      echo "  ↳ Added to $profile"
    fi
  done
}

# ─── Node.js ──────────────────────────────────────────────────────────────────

install_node() {
  echo ""
  echo "=== Checking Node.js & npm ==="

  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    echo "✅ Node $(node -v) and npm $(npm -v) already installed."
    return
  fi

  echo "Node.js not found. Installing..."

  case "$OS" in
    macos)
      if command -v brew &>/dev/null; then
        brew install node
      else
        echo "Homebrew not found. Installing nvm instead..."
        install_node_via_nvm
      fi
      ;;
    debian)
      curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
      sudo apt-get install -y nodejs
      ;;
    fedora|rhel)
      curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
      sudo dnf install -y nodejs || sudo yum install -y nodejs
      ;;
    *)
      echo "Unsupported OS. Attempting nvm fallback..."
      install_node_via_nvm
      ;;
  esac

  # Ensure npm bin is on PATH
  local npm_prefix
  npm_prefix="$(npm config get prefix 2>/dev/null || true)"
  if [[ -n "$npm_prefix" ]]; then
    add_to_path_profiles "export PATH=\"$npm_prefix/bin:\$PATH\""
  fi

  echo "✅ Node $(node -v) and npm $(npm -v) installed."
}

install_node_via_nvm() {
  local nvm_dir="${NVM_DIR:-$HOME/.nvm}"
  if [[ ! -d "$nvm_dir" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
  export NVM_DIR="$nvm_dir"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts

  add_to_path_profiles "export NVM_DIR=\"\$HOME/.nvm\""
  add_to_path_profiles "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\""
}

# ─── Python ───────────────────────────────────────────────────────────────────

install_python() {
  echo ""
  echo "=== Checking Python 3 & pip ==="

  if command -v python3 &>/dev/null && command -v pip3 &>/dev/null; then
    echo "✅ $(python3 --version) and pip $(pip3 --version | awk '{print $2}') already installed."
    return
  fi

  echo "Python 3 not found. Installing..."

  case "$OS" in
    macos)
      if command -v brew &>/dev/null; then
        brew install python3
        BREW_PREFIX="$(brew --prefix)"
        add_to_path_profiles "export PATH=\"$BREW_PREFIX/bin:\$PATH\""
      else
        echo "Homebrew required on macOS for Python installation."
        echo "Install Homebrew first: https://brew.sh"
        exit 1
      fi
      ;;
    debian)
      sudo apt-get update -qq
      sudo apt-get install -y python3 python3-pip python3-venv
      ;;
    fedora|rhel)
      sudo dnf install -y python3 python3-pip || sudo yum install -y python3 python3-pip
      ;;
    *)
      echo "Unsupported OS. Please install Python 3 manually."
      exit 1
      ;;
  esac

  echo "✅ $(python3 --version) installed."
}

# ─── Go ───────────────────────────────────────────────────────────────────────

install_go() {
  echo ""
  echo "=== Checking Go ==="

  if command -v go &>/dev/null; then
    echo "✅ $(go version) already installed."
    return
  fi

  echo "Go not found. Installing..."

  case "$OS" in
    macos)
      if command -v brew &>/dev/null; then
        brew install go
        BREW_PREFIX="$(brew --prefix)"
        add_to_path_profiles "export PATH=\"$BREW_PREFIX/bin:\$PATH\""
      else
        echo "Homebrew required on macOS for Go installation."
        echo "Install Homebrew first: https://brew.sh"
        exit 1
      fi
      ;;
    debian)
      sudo apt-get update -qq
      sudo apt-get install -y golang-go
      add_to_path_profiles "export PATH=\"\$PATH:/usr/local/go/bin\""
      ;;
    fedora|rhel)
      sudo dnf install -y golang || sudo yum install -y golang
      add_to_path_profiles "export PATH=\"\$PATH:/usr/local/go/bin\""
      ;;
    *)
      echo "Unsupported OS. Please install Go manually from https://go.dev/dl/"
      exit 1
      ;;
  esac

  # GOPATH
  add_to_path_profiles "export GOPATH=\"\$HOME/go\""
  add_to_path_profiles "export PATH=\"\$PATH:\$GOPATH/bin\""

  echo "✅ $(go version) installed."
}

# ─── Dispatch ─────────────────────────────────────────────────────────────────

echo ""
echo "======================================================"
echo " Gemini Skill – Prerequisites Installer"
echo " Stack : $STACK"
echo " OS    : $OS"
echo "======================================================"

case "$STACK" in
  js-web|js-web-genkit)
    install_node
    ;;
  py-web|py-notebook)
    install_python
    ;;
  go-web)
    install_go
    ;;
  *)
    echo "❌ Unknown stack: '$STACK'"
    echo "   Valid options: js-web | js-web-genkit | py-web | py-notebook | go-web"
    exit 1
    ;;
esac

echo ""
echo "======================================================"
echo " ✅ Prerequisites check complete for: $STACK"
echo " If any runtime was just installed, run:"
echo "   source ~/.zshrc   (or open a new terminal)"
echo "======================================================"
