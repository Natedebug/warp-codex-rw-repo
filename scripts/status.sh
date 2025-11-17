#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

section() {
  printf '\n== %s ==\n' "$1"
}

section "Repository status ($(date -u '+%Y-%m-%d %H:%M UTC'))"

section "Git working tree"
if git status -sb >/dev/null 2>&1; then
  git status -sb
else
  echo "git status unavailable"
fi

section "Codex requests for Warp"
if [[ -f reports/codex-requests.md ]]; then
  sed 's/^/  /' reports/codex-requests.md
else
  echo "  (none recorded)"
fi

section "Latest Warp change log entry"
if [[ -f reports/warp-changes.md ]]; then
  awk '
    /^## / { if (seen) exit; seen=1 }
    seen { print "  " $0 }
  ' reports/warp-changes.md
  if ! grep -q '^## ' reports/warp-changes.md; then
    echo "  (no entries yet)"
  fi
else
  echo "  reports/warp-changes.md not found"
fi

section "Next steps"
cat <<'NEXT'
  - Run this script at the start of every session to see pending work.
  - Update reports/codex-requests.md and reports/warp-changes.md as you hand tasks off.
NEXT
