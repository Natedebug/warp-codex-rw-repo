#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-data/input.txt}"

if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  echo "Usage: $0 [file]  (defaults to data/input.txt)" >&2
  exit 1
fi

cat "$FILE"
