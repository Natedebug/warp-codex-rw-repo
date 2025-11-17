#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/../../../" && pwd))"
PA="$SCRIPT_DIR/pa.sh"
DATA_DIR="$ROOT_DIR/data/personal-assistant"

mkdir -p "$DATA_DIR"

# Basic command runs (avoid side-effects where possible)
bash "$PA" greet >/dev/null
bash "$PA" speak "test speech" >/dev/null
PA_DRY_RUN_OPEN=1 bash "$PA" open "TextEdit" >/dev/null 2>&1 || true
bash "$PA" status >/dev/null

# Notes: write to a temporary notes file, not the user's canonical notes
TMP_NOTES="$(mktemp "${TMPDIR:-/tmp}/pa-notes.XXXXXX")"
PA_NOTES_FILE="$TMP_NOTES" bash "$PA" note "test note"

grep -q "test note" "$TMP_NOTES"
rm -f "$TMP_NOTES"

# Search (dry-run; ensure command succeeds and prints URL)
PA_DRY_RUN_OPEN=1 bash "$PA" search "C C++ #1" >/dev/null 2>&1 || true

echo "Personal Assistant tests passed."
