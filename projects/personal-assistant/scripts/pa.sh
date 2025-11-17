#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/../../../" && pwd))"
DATA_DIR="$ROOT_DIR/data/personal-assistant"
NOTES_FILE="$DATA_DIR/notes.txt"
VERSION="0.1.0"

mkdir -p "$DATA_DIR"

usage() {
  cat <<'USAGE'
Personal Assistant (macOS-first)

Usage: pa <command> [args]

Commands:
  help                  Show this help
  version               Print version
  greet                 Print and (if possible) speak a greeting
  speak <text>          Speak text using macOS 'say' when available
  open <App Name>       Open a macOS application (e.g., "Notes")
  note <text>           Append a timestamped note to data/personal-assistant/notes.txt
  search <query>        Open default browser to a web search for the query
  status                Show brief system status (battery, volume)

Examples:
  pa greet
  pa speak "Welcome back"
  pa open "Calendar"
  pa note "Buy coffee"
  pa search "weather in SF"
USAGE
}

say_if_available() {
  if command -v say >/dev/null 2>&1; then
    say "$1" || true
  fi
}

urlencode() {
  # URL-encode the input string
  local LC_ALL=C
  local s="$*"
  local i c e=""
  for (( i=0; i<${#s}; i++ )); do
    c=${s:$i:1}
    case "$c" in
      [a-zA-Z0-9.~_-]) e+="$c" ;;
      ' ') e+="+" ;;
      *) printf -v hex '%%%02X' "'"$c; e+="$hex" ;;
    esac
  done
  printf '%s' "$e"
}

battery_status() {
  if command -v pmset >/dev/null 2>&1; then
    pmset -g batt 2>/dev/null | head -n1 | sed 's/.*Battery Power;//; s/.*Now;//; s/.*InternalBattery-\d+;//' || true
  fi
}

volume_status() {
  if command -v osascript >/dev/null 2>&1; then
    osascript -e 'output volume of (get volume settings)' 2>/dev/null || true
  fi
}

cmd_greet() {
  local msg="Hello! I'm your personal assistant."
  echo "$msg"
  say_if_available "$msg"
}

cmd_speak() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 speak <text>" >&2
    exit 1
  fi
  local text="$*"
  echo "$text"
  say_if_available "$text"
}

cmd_open() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 open <App Name>" >&2
    exit 1
  fi
  open -a "$*"
}

cmd_note() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 note <text>" >&2
    exit 1
  fi
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S %Z')"
  printf '[%s] %s\n' "$ts" "$*" >> "$NOTES_FILE"
  echo "Saved note to $NOTES_FILE"
}

cmd_search() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 search <query>" >&2
    exit 1
  fi
  local q
  q=$(urlencode "$*")
  open "https://www.google.com/search?q=$q"
}

cmd_status() {
  echo "Status:"
  local batt vol
  batt=$(battery_status || true)
  vol=$(volume_status || true)
  [[ -n "${batt:-}" ]] && echo "  Battery: $batt" || echo "  Battery: (unavailable)"
  [[ -n "${vol:-}" ]] && echo "  Volume: $vol" || echo "  Volume: (unavailable)"
}

main() {
  local cmd
  cmd="${1:-help}"
  shift || true
  case "$cmd" in
    help|-h|--help) usage ;;
    version|--version) echo "$VERSION" ;;
    greet) cmd_greet "$@" ;;
    speak) cmd_speak "$@" ;;
    open) cmd_open "$@" ;;
    note) cmd_note "$@" ;;
    search) cmd_search "$@" ;;
    status) cmd_status "$@" ;;
    *) echo "Unknown command: $cmd" >&2; echo "Try: $0 help" >&2; exit 1 ;;
  esac
}

main "$@"
