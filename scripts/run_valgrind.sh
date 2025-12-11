
#!/usr/bin/env bash
# Runs the compiled executable under valgrind and writes results to results.txt or valgrind-errors.txt
# Also writes program-check.txt/program-error.txt for missing executable.
# Exits non-zero if leaks/errors are found or if executable missing.

set -u

EXEC="${EXECUTABLE:-main}"
PROG_CHECK="program-check.txt"
PROG_ERR="program-error.txt"
VG_LOG="valgrind.log"
RES="results.txt"
ERR="valgrind-errors.txt"

echo "Checking for executable ./$EXEC" > "$PROG_CHECK"
if [ ! -x "./$EXEC" ]; then
  echo "EXECUTABLE_MISSING: ./$EXEC not found or not executable" >> "$PROG_CHECK"
  cp "$PROG_CHECK" "$PROG_ERR"
  exit 1
fi

# Run valgrind, always capture its output to valgrind.log
# Use --error-exitcode so valgrind sets non-zero on errors/leaks; we still continue to inspect log
valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --log-file="$VG_LOG" ./"$EXEC" >> "$VG_LOG" 2>&1 || true

# Determine success: look for "ERROR SUMMARY: 0 errors" AND "definitely lost: 0 bytes"
if grep -q "ERROR SUMMARY: 0 errors" "$VG_LOG" && grep -q "definitely lost: 0 bytes" "$VG_LOG"; then
  {
    echo "VALGRIND_OK - no leaks or errors detected"
    echo ""
    echo "Full valgrind output:"
    cat "$VG_LOG"
  } > "$RES"
  exit 0
else
  {
    echo "VALGRIND_ERRORS - see valgrind.log for full details"
    echo ""
    echo "Full valgrind output:"
    cat "$VG_LOG"
  } > "$ERR"
  exit 1
fi
