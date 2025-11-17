#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/../../../" && pwd))"
DATA_DIR="$ROOT_DIR/data/personal-assistant"
# Optional permissions configuration
CONFIG_DIR="$ROOT_DIR/projects/personal-assistant/config"
PERMISSIONS_FILE="${PA_PERMISSIONS_FILE:-$CONFIG_DIR/permissions.env}"
PERMISSIONS_LIB="$ROOT_DIR/projects/personal-assistant/src/permissions.sh"
# Allow overriding notes storage for tests via PA_NOTES_FILE
NOTES_FILE="${PA_NOTES_FILE:-$DATA_DIR/notes.txt}"
VERSION="0.1.0"

mkdir -p "$DATA_DIR"

# shellcheck source=../src/permissions.sh
if [[ -f "$PERMISSIONS_LIB" ]]; then
  # shellcheck disable=SC1090
  source "$PERMISSIONS_LIB"
fi

if [[ -f "$PERMISSIONS_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$PERMISSIONS_FILE"
fi

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
  read <path>           Read a file after verifying read permissions
  write <path> <text>   Append text to a file when write permissions allow

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
  # Prefer Python for robust encoding; fall back to a POSIX-safe shell impl
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$@" <<'PY'
import sys, urllib.parse
print(urllib.parse.quote_plus(" ".join(sys.argv[1:])))
PY
    return 0
  fi
  local LC_ALL=C
  local s="$*"
  local i c
  for (( i=0; i<${#s}; i++ )); do
    c=${s:$i:1}
    case "$c" in
      [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
      ' ') printf '+' ;;
      *) printf '%%%02X' "'"$c ;;
    esac
  done
}

battery_status() {
  if command -v pmset >/dev/null 2>&1; then
    # Extract a concise status like "86% discharging" from pmset output
    pmset -g batt 2>/dev/null | awk -F';' '/%/ {
      # $1 ends with e.g. "... 86%"; $2 contains state like " discharging"
      gsub(/.*[[:space:]]/, "", $1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
      printf "%s %s\n", $1, $2
      exit
    }' || true
  fi
}

volume_status() {
  if command -v osascript >/dev/null 2>&1; then
    osascript -e 'output volume of (get volume settings)' 2>/dev/null || true
  fi
}

wifi_status() {
  local ssid="" interface="" airport_bin="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  if [[ -x "$airport_bin" ]]; then
    ssid="$("$airport_bin" -I 2>/dev/null | awk -F': ' '/ SSID/ {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2; exit}' || true)"
  elif command -v networksetup >/dev/null 2>&1; then
    interface="$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi|AirPort/ {getline; if ($1 == "Device:") {print $2; exit}}' || true)"
    if [[ -n "${interface:-}" ]]; then
      ssid="$(networksetup -getairportnetwork "$interface" 2>/dev/null | awk -F': ' '/Current Wi-Fi Network/ {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2; exit}' || true)"
    fi
  fi
  printf '%s' "$ssid"
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
  local app="$*"
  if command -v osascript >/dev/null 2>&1; then
    if ! osascript -e 'id of application "'"'"'"'$app'"'"'"'"' >/dev/null 2>&1; then
      echo "App not found: $app" >&2
      exit 1
    fi
  else
    local candidate
    for candidate in "/Applications/$app.app" \
      "/System/Applications/$app.app" \
      "$HOME/Applications/$app.app"; do
      if [[ -d "$candidate" ]]; then
        break
      fi
      candidate=""
    done
    if [[ -z "${candidate:-}" ]]; then
      echo "App not found: $app" >&2
      exit 1
    fi
  fi
  if [[ "${PA_DRY_RUN_OPEN:-0}" = 1 ]]; then
    echo "(dry-run) Would open app: $app"
    return 0
  fi
  open -a "$app"
}

cmd_note() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 note <text>" >&2
    exit 1
  fi
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S %Z')"
  require_write_permission "$NOTES_FILE"
  printf '[%s] %s\n' "$ts" "$*" >> "$NOTES_FILE"
  echo "Saved note to $NOTES_FILE"
}

cmd_search() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 search <query>" >&2
    exit 1
  fi
  local engine url q
  q=$(urlencode "$*")
  engine="${PA_SEARCH_ENGINE:-google}"
  case "$engine" in
    google) url="https://www.google.com/search?q=$q" ;;
    ddg|duckduckgo) url="https://duckduckgo.com/?q=$q" ;;
    bing) url="https://www.bing.com/search?q=$q" ;;
    *) url="https://www.google.com/search?q=$q" ;;
  esac
  if [[ "${PA_DRY_RUN_OPEN:-0}" = 1 ]]; then
    echo "(dry-run) Would open URL: $url"
    return 0
  fi
  open "$url"
}

battery_time_remaining() {
  if command -v pmset >/dev/null 2>&1; then
    pmset -g batt 2>/dev/null | awk -F';' '/%/ {
      # Field 3 often contains time like " 3:44 remaining" or " (no estimate)"
      if (NF >= 3) {
        t=$3
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", t)
        sub(/ present:.*/, "", t)
        print t
      }
      exit
    }' || true
  fi
}

cmd_status() {
  echo "Status:"
  local batt vol wifi time
  batt=$(battery_status || true)
  vol=$(volume_status || true)
  wifi=$(wifi_status || true)
  time=$(battery_time_remaining || true)
  [[ -n "${batt:-}" ]] && echo "  Battery: $batt" || echo "  Battery: (unavailable)"
  [[ -n "${time:-}" ]] && echo "  Battery time: $time" || true
  [[ -n "${vol:-}" ]] && echo "  Volume: $vol" || echo "  Volume: (unavailable)"
  [[ -n "${wifi:-}" ]] && echo "  Wi-Fi: $wifi" || echo "  Wi-Fi: (offline/unavailable)"
}

cmd_read() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 read <path>" >&2
    exit 1
  fi
  local abs
  abs=$(ensure_readable_path "$1")
  cat "$abs"
}

cmd_write() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: $0 write <path> <text>" >&2
    exit 1
  fi
  local target="$1"
  shift
  require_write_permission "$target"
  local abs
  abs=$(resolve_pa_path "$target")
  printf '%s\n' "$*" >> "$abs"
  echo "Saved text to $abs"
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
    read) cmd_read "$@" ;;
    write) cmd_write "$@" ;;
    *) echo "Unknown command: $cmd" >&2; echo "Try: $0 help" >&2; exit 1 ;;
  esac
}

main "$@"
