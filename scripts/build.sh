#!/usr/bin/env bash
# Runs make and writes build output to build.txt

set -u

OUT="build.txt"
echo "Running make..." > "$OUT"

if make >> "$OUT" 2>&1; then
  echo "BUILD_SUCCESS" >> "$OUT"
else
  echo "BUILD_FAILED - see build.txt for details" >> "$OUT"
  exit 1
fi
