#!/usr/bin/env bash
set -euo pipefail

OUTPUT="${1:-data/output.txt}"
shift || true

# Ensure parent directory exists
mkdir -p "$(dirname "$OUTPUT")"

# Determine content: from args (preferred) or stdin
if [[ $# -gt 0 ]]; then
  CONTENT="$*"
elif [ -t 0 ]; then
  echo "Usage: echo 'text' | $0 [output_file]  OR  $0 [output_file] 'text'" >&2
  exit 1
else
  CONTENT="$(cat -)"
fi

printf "%s\n" "$CONTENT" > "$OUTPUT"
BYTES=$(wc -c < "$OUTPUT" | tr -d ' ')
echo "Wrote ${BYTES} bytes to $OUTPUT"
