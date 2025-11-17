#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/.." && pwd))"
HOOKS_SOURCE="$ROOT_DIR/hooks"
HOOKS_TARGET="$ROOT_DIR/.git/hooks"

if [[ ! -d "$ROOT_DIR/.git" ]]; then
  echo "ERROR: .git directory not found at $ROOT_DIR; run this from inside a git checkout." >&2
  exit 1
fi

mkdir -p "$HOOKS_TARGET"

hook="pre-push"
src="$HOOKS_SOURCE/$hook"
dest="$HOOKS_TARGET/$hook"
if [[ ! -f "$src" ]]; then
  echo "Skipping $hook (no source script at $src)" >&2
else
  cp "$src" "$dest"
  chmod +x "$dest"
  echo "Installed $hook hook to $dest"
fi

echo "Git hooks installed. Future pushes to blocked branches will be rejected locally."
