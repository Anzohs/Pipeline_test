#!/usr/bin/env bash
# Installs @42school/norminette and writes install logs to install.txt

set -u

OUT="install.txt"
echo "Installing @42school/norminette..." > "$OUT"

if npm install -g @42school/norminette@latest >> "$OUT" 2>&1; then
  echo "INSTALL_SUCCESS" >> "$OUT"
else
  echo "INSTALL_FAILED - see install.txt for details" >> "$OUT"
  exit 1
fi

# Verify
if norminette --version >> "$OUT" 2>&1; then
  echo "NORMINETTE_VERIFIED" >> "$OUT"
else
  echo "NORMINETTE_VERIFY_FAILED" >> "$OUT"
  exit 1
fi
