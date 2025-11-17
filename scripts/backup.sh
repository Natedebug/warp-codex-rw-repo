#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 path/to/file" >&2
  exit 1
fi

TARGET="$1"

if [[ ! -f "$TARGET" ]]; then
  echo "Error: file not found: $TARGET" >&2
  exit 1
fi

TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
BACKUP_ROOT="backups/$TIMESTAMP"
BACKUP_PATH="$BACKUP_ROOT/$TARGET"

mkdir -p "$(dirname "$BACKUP_PATH")"

# Move the pristine original into the timestamped backup tree.
mv "$TARGET" "$BACKUP_PATH"

# Copy the backup back to the original path to create the editable working copy.
cp "$BACKUP_PATH" "$TARGET"

echo "Backed up $TARGET to $BACKUP_PATH and restored a working copy for editing."
