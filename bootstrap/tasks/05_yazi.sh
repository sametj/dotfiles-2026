#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

yazi_task() {
  log "[yazi] Configuring Yazi..."

  if ! has_cmd yazi; then
    die "[yazi] yazi not installed. It should be installed by 01_packages.sh"
  fi

  log "[yazi] Yazi installed: $(command -v yazi)"

  # future config hooks could go here
  # (themes, preview config, keybinds, etc.)

  log "[yazi] Done."
}

yazi_task "$@"
