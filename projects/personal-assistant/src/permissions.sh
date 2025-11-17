#!/usr/bin/env bash
# shellcheck shell=bash

# Resolve a path to an absolute path with user-home expansion.
resolve_pa_path() {
  local raw="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$raw" <<'PY'
import os, sys
path = os.path.abspath(os.path.expanduser(sys.argv[1]))
print(path)
PY
  else
    # Fallback: use POSIX realpath-like resolution via cd
    printf '%s/%s\n' "$(cd "$(dirname "$raw")" 2>/dev/null && pwd)" "$(basename "$raw")"
  fi
}

# Check whether a path is inside one of the allowed directories (colon-separated list).
pa_path_allowed() {
  local target="$1" allowed_list="$2" entry resolved
  IFS=':' read -r -a entries <<<"$allowed_list"
  for entry in "${entries[@]}"; do
    [[ -z "$entry" ]] && continue
    resolved=$(resolve_pa_path "$entry")
    if [[ "$target" == "$resolved" || "$target" == "$resolved"/* ]]; then
      return 0
    fi
  done
  return 1
}

require_read_permission() {
  if [[ "${PA_ALLOW_READ:-1}" != "1" ]]; then
    echo "Read access is disabled. Set PA_ALLOW_READ=1 to enable reads." >&2
    exit 1
  fi
}

require_write_permission() {
  local target="$1"
  local allow="${PA_ALLOW_WRITE:-1}"
  local default_write_dirs="$DATA_DIR:${NOTES_FILE:+$(dirname "$NOTES_FILE")}" 
  local allowed_dirs="${PA_ALLOWED_WRITE_DIRS:-$default_write_dirs}"
  local confirm="${PA_CONFIRM_WRITE:-0}"

  if [[ "$allow" != "1" ]]; then
    echo "Write access is disabled. Set PA_ALLOW_WRITE=1 to permit writes." >&2
    exit 1
  fi

  local abs_target
  abs_target=$(resolve_pa_path "$target")

  if ! pa_path_allowed "$abs_target" "$allowed_dirs"; then
    echo "Blocked write to $abs_target (outside PA_ALLOWED_WRITE_DIRS)." >&2
    exit 1
  fi

  if [[ "$confirm" = "1" && -t 0 ]]; then
    read -r -p "Allow writing to $abs_target? [y/N] " reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
      echo "Write cancelled." >&2
      exit 1
    fi
  fi
}

ensure_readable_path() {
  require_read_permission
  local target="$1"
  local abs
  abs=$(resolve_pa_path "$target")
  if [[ ! -e "$abs" ]]; then
    echo "File not found: $abs" >&2
    exit 1
  fi
  if [[ ! -r "$abs" ]]; then
    echo "File not readable: $abs" >&2
    exit 1
  fi
  printf '%s' "$abs"
}
