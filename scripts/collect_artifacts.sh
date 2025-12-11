#!/usr/bin/env bash
# Collect only existing artifact files into artifacts/ for upload by actions/upload-artifact
# This script is safe to run on failure (always exits 0).

set -u

DEST="artifacts"
mkdir -p "$DEST"

files=(
  "install.txt"
  "build.txt"
  "valgrind-install.txt"
  "valgrind.log"
  "results.txt"
  "valgrind-errors.txt"
  "program-error.txt"
  "program-check.txt"
)

copied=0
for f in "${files[@]}"; do
  if [ -f "$f" ]; then
    cp -v -- "$f" "$DEST/"
    copied=$((copied + 1))
  fi
done

echo "Collected $copied files into $DEST"
ls -la "$DEST" || true

# Always exit 0 so artifact collection doesn't mark job failed
exit 0
