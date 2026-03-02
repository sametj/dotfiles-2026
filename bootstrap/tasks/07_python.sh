#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

python_cli_task() {
  log "[python] Installing pipx + Python CLI tools..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y python3 python3-venv python3-pip pipx

  # Make pipx binaries available
  pipx ensurepath

  # Install tools safely (isolated venv per tool)
  if ! command -v black >/dev/null 2>&1; then
    pipx install black
  fi

  log "[python] Done."
}

python_cli_task "$@"
