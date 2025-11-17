#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Running lint (shellcheck)..."
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "$ROOT_DIR"/scripts/*.sh
else
  echo "shellcheck not found; skipping lint step." >&2
fi

echo "Running sample read/write round-trip..."
TEMP_OUTPUT="$ROOT_DIR/data/output.test.txt"
trap 'rm -f "$TEMP_OUTPUT"' EXIT

echo "sample validation text" | "$ROOT_DIR/scripts/write.sh" "$TEMP_OUTPUT" >/dev/null
READ_BACK="$("$ROOT_DIR/scripts/read.sh" "$TEMP_OUTPUT")"

if [[ "$READ_BACK" != "sample validation text" ]]; then
  echo "Round-trip read/write produced unexpected content:" >&2
  printf "Expected: %s\nActual: %s\n" "sample validation text" "$READ_BACK" >&2
  exit 1
fi

echo "All validations completed successfully."
