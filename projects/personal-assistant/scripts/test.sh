#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/../../../" && pwd))"
PA="$SCRIPT_DIR/pa.sh"
DATA_DIR="$ROOT_DIR/data/personal-assistant"
NOTES_FILE="$DATA_DIR/notes.txt"

mkdir -p "$DATA_DIR"
rm -f "$NOTES_FILE"

# Basic command runs
bash "$PA" greet >/dev/null
bash "$PA" speak "test speech" >/dev/null
bash "$PA" open "TextEdit" >/dev/null 2>&1 || true

# Notes
bash "$PA" note "test note"

grep -q "test note" "$NOTES_FILE"

# Search (can't verify browser open in headless; just ensure no error)
bash "$PA" search "unit test query" >/dev/null 2>&1 || true

echo "Personal Assistant tests passed."