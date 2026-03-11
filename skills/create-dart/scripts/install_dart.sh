#!/bin/bash
set -e

# 1. Determine OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)
    OS_NAME="linux"
    ;;
  Darwin)
    OS_NAME="macos"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64)
    ARCH_NAME="x64"
    ;;
  arm64 | aarch64)
    ARCH_NAME="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# 2. Get latest stable version
# Using a recent stable version.
DART_VERSION="3.3.3"
ZIP_FILE="dartsdk-${OS_NAME}-${ARCH_NAME}-release.zip"
DOWNLOAD_URL="https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/${ZIP_FILE}"

# 3. Download and extract
INSTALL_DIR="/usr/local/lib/dart-sdk"
TARGET_BIN="/usr/local/bin"
TMP_DIR="/tmp/dart-sdk-install"

echo "Downloading from $DOWNLOAD_URL..."
curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL"

# Prepare installation directory
sudo mkdir -p "$INSTALL_DIR"
mkdir -p "$TMP_DIR"

echo "Extracting to $TMP_DIR..."
unzip -o "$ZIP_FILE" -d "$TMP_DIR"

echo "Moving SDK to $INSTALL_DIR..."
sudo mv "$TMP_DIR/dart-sdk"/* "$INSTALL_DIR"


# 4. Create symlinks
echo "Creating symlinks in $TARGET_BIN..."
sudo ln -sf "$INSTALL_DIR/bin/dart" "$TARGET_BIN/dart"
sudo ln -sf "$INSTALL_DIR/bin/dartaotruntime" "$TARGET_BIN/dartaotruntime"
sudo ln -sf "$INSTALL_DIR/bin/dartdoc" "$TARGET_BIN/dartdoc"
sudo ln -sf "$INSTALL_DIR/bin/pub" "$TARGET_BIN/pub"

# 5. Cleanup
rm "$ZIP_FILE"
rm -rf "$TMP_DIR"

echo "Dart SDK installation complete!"
echo "Please restart your shell for changes to take effect."
