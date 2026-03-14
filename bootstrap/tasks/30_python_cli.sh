#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

python_cli_task() {
  log "[python] Installing pipx + Python CLI tools..."

  has_cmd pipx || die "[python] pipx is required but not installed."

  pipx ensurepath || true

  if ! has_cmd black; then
    pipx install black
  else
    log "[python] black already installed: $(command -v black)"
  fi

  log "[python] Done."
}

python_cli_task "$@"
