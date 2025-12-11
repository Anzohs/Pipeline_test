#!/usr/bin/env bash
# Clone the 42school/norminette repository and install it using pip.
# Writes logs to install.txt and exits non-zero on failure.
#
# Notes:
# - Workflow sets up Python 3.10+ using actions/setup-python before running this script.
# - This installs from the git repository (no npm involved).
# - If you'd prefer pipx or a virtualenv install, I can provide that variant.

set -euo pipefail

OUT="install.txt"
REPO_URL="https://github.com/42school/norminette.git"
CLONE_DIR="norminette_repo"

echo "Installing norminette from ${REPO_URL}..." > "$OUT"
echo "Python version:" >> "$OUT"
python3 --version >> "$OUT" 2>&1 || true
echo "" >> "$OUT"

# Clean any previous clone to avoid weirdness
if [ -d "$CLONE_DIR" ]; then
  rm -rf "$CLONE_DIR"
fi

# Clone the repository (shallow)
if git clone --depth 1 "$REPO_URL" "$CLONE_DIR" >> "$OUT" 2>&1; then
  echo "GIT_CLONE_SUCCESS" >> "$OUT"
else
  echo "GIT_CLONE_FAILED - see install.txt for details" >> "$OUT"
  exit 1
fi

# Install via pip from the cloned repository
cd "$CLONE_DIR"
echo "" >> "../$OUT"
echo "Upgrading pip and setuptools..." >> "../$OUT"
if python3 -m pip install --upgrade pip setuptools >> "../$OUT" 2>&1; then
  echo "PIP_UPGRADE_SUCCESS" >> "../$OUT"
else
  echo "PIP_UPGRADE_FAILED - see install.txt for details" >> "../$OUT"
  exit 1
fi

echo "" >> "../$OUT"
echo "Installing norminette from cloned repo..." >> "../$OUT"
if python3 -m pip install . >> "../$OUT" 2>&1; then
  echo "INSTALL_SUCCESS (pip install .)" >> "../$OUT"
else
  echo "INSTALL_FAILED - pip install from cloned repo failed (see install.txt)" >> "../$OUT"
  exit 1
fi

# Verify the norminette command is available and print version
echo "" >> "../$OUT"
if command -v norminette >/dev/null 2>&1; then
  echo "norminette found at: $(command -v norminette)" >> "../$OUT"
  if norminette --version >> "../$OUT" 2>&1; then
    echo "NORMINETTE_VERIFIED" >> "../$OUT"
    exit 0
  else
    echo "NORMINETTE_VERIFY_FAILED - running norminette --version failed" >> "../$OUT"
    exit 1
  fi
else
  echo "NORMINETTE_NOT_INSTALLED_IN_PATH - installation succeeded but norminette command not found" >> "../$OUT"
  exit 1
fi
