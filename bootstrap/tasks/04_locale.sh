#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

locale_task() {
  log "[locale] Ensuring UTF-8 locale (en_US.UTF-8)..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y locales

  # Generate and set locale
  sudo locale-gen en_US.UTF-8
  sudo update-locale LANG=en_US.UTF-8

  log "[locale] Done. You may need to restart the shell (exec zsh) or WSL for all apps to inherit it."
}

locale_task "$@"
