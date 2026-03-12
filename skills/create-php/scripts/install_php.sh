#!/bin/bash
# A script to install PHP
set -e

# Check if PHP is already installed
if [ -x "$(command -v php)" ]; then
  echo "PHP is already installed."
  exit 0
fi

# Update package list and install PHP
if [ -x "$(command -v apt-get)" ]; then
  apt-get update
  apt-get install -y php
elif [ -x "$(command -v yum)" ]; then
  yum install -y php
elif [ -x "$(command -v dnf)" ]; then
  dnf install -y php
else
  echo "Error: Could not find a package manager (apt-get, yum, dnf). Please install PHP manually." >&2
  exit 1
fi

echo "PHP installed successfully."
