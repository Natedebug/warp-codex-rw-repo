#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/../../../" && pwd))"
ENV_ROOT="$ROOT_DIR/projects/personal-assistant/.macos-12.6.1-sim"
BIN_DIR="$ENV_ROOT/bin"

mkdir -p "$BIN_DIR"

create_pmset() {
  cat <<'PMSET' > "$BIN_DIR/pmset"
#!/usr/bin/env bash
set -euo pipefail
if [[ "$#" -ge 2 && "$1" == "-g" && "$2" == "batt" ]]; then
  cat <<'OUT'
Now drawing from 'Battery Power'
 -InternalBattery-0 (id=1234567)  86%; discharging; 3:44 remaining present: true
OUT
  exit 0
fi
echo "pmset stub: unsupported args $*" >&2
exit 1
PMSET
  chmod +x "$BIN_DIR/pmset"
}

create_osascript() {
  cat <<'OSASCRIPT' > "$BIN_DIR/osascript"
#!/usr/bin/env bash
set -euo pipefail
# Respond to volume queries and app identifier lookups
if [[ "$#" -ge 2 && "$1" == "-e" ]]; then
  case "$2" in
    *"output volume of"*)
      echo "42"
      exit 0
      ;;
    *"id of application"*)
      # Return a predictable bundle id for simulated apps
      app_name=$(printf "%s" "$2" | sed -n "s/.*id of application ['\"]\(.*\)['\"].*/\1/p")
      [[ -z "$app_name" ]] && app_name="App"
      echo "com.apple.$(echo "$app_name" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')"
      exit 0
      ;;
  esac
fi
echo "osascript stub: unsupported args $*" >&2
exit 1
OSASCRIPT
  chmod +x "$BIN_DIR/osascript"
}

create_say() {
  cat <<'SAY' > "$BIN_DIR/say"
#!/usr/bin/env bash
set -euo pipefail
printf "say: %s\n" "$*"
SAY
  chmod +x "$BIN_DIR/say"
}

create_open() {
  cat <<'OPEN' > "$BIN_DIR/open"
#!/usr/bin/env bash
set -euo pipefail
echo "open: $*"
OPEN
  chmod +x "$BIN_DIR/open"
}

create_networksetup() {
  cat <<'NETSET' > "$BIN_DIR/networksetup"
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == "-listallhardwareports" ]]; then
  cat <<'OUT'
Hardware Port: Wi-Fi
Device: en0
Ethernet Address: aa:bb:cc:dd:ee:ff
OUT
  exit 0
fi
if [[ "$1" == "-getairportnetwork" && -n "${2:-}" ]]; then
  echo "Current Wi-Fi Network: TestWifi"
  exit 0
fi
echo "networksetup stub: unsupported args $*" >&2
exit 1
NETSET
  chmod +x "$BIN_DIR/networksetup"
}

create_activate() {
  cat <<'ACTIVATE' > "$ENV_ROOT/activate"
# shellcheck shell=bash
# Source this file to activate the macOS 12.6.1 (MacBook Pro M1 Pro) simulation.
export _PA_SIM_OLD_PATH="${_PA_SIM_OLD_PATH:-$PATH}"
export PATH="__BIN_DIR__:${PATH}"
export _PA_SIM_OLD_DRY_RUN_OPEN="${_PA_SIM_OLD_DRY_RUN_OPEN:-${PA_DRY_RUN_OPEN:-}}"
export PA_DRY_RUN_OPEN="${PA_DRY_RUN_OPEN:-1}"
export PA_SIM_MAC_MODEL="MacBookPro18,3"
export PA_SIM_MACOS_VERSION="12.6.1"
echo "Activated personal-assistant macOS 12.6.1 (MacBook Pro M1 Pro) simulation."
ACTIVATE
  python3 - "$ENV_ROOT/activate" "$BIN_DIR" <<'PY'
import pathlib, sys
target = pathlib.Path(sys.argv[1])
bin_dir = sys.argv[2]
target.write_text(target.read_text().replace("__BIN_DIR__", bin_dir))
PY
}

create_deactivate() {
  cat <<'DEACTIVATE' > "$ENV_ROOT/deactivate"
# shellcheck shell=bash
# Source this file to restore the previous PATH and unset simulation metadata.
if [[ -n "${_PA_SIM_OLD_PATH:-}" ]]; then
  export PATH="${_PA_SIM_OLD_PATH}"
  unset _PA_SIM_OLD_PATH
fi
if [[ -n "${_PA_SIM_OLD_DRY_RUN_OPEN:-}" ]]; then
  export PA_DRY_RUN_OPEN="${_PA_SIM_OLD_DRY_RUN_OPEN}"
else
  unset PA_DRY_RUN_OPEN
fi
unset _PA_SIM_OLD_DRY_RUN_OPEN
unset PA_SIM_MAC_MODEL
unset PA_SIM_MACOS_VERSION
echo "Deactivated personal-assistant macOS simulation."
DEACTIVATE
}

create_pmset
create_osascript
create_say
create_open
create_networksetup
create_activate
create_deactivate

echo "macOS 12.6.1 simulation created at $ENV_ROOT"
echo "Activate with: source $ENV_ROOT/activate"
echo "Deactivate with: source $ENV_ROOT/deactivate"
