#!/usr/bin/env bash
# Installs valgrind and writes install logs to valgrind-install.txt

set -u

OUT="valgrind-install.txt"
echo "Installing valgrind..." > "$OUT"

if sudo apt-get update >> "$OUT" 2>&1 && sudo apt-get install -y valgrind >> "$OUT" 2>&1; then
  echo "VALGRIND_INSTALL_SUCCESS" >> "$OUT"
else
  echo "VALGRIND_INSTALL_FAILED - see valgrind-install.txt for details" >> "$OUT"
  exit 1
fi
