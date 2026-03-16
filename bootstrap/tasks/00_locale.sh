#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

locale_task() {
  ensure_supported_platform

  case "${PLATFORM:-}" in
  macos)
    log "[locale] macOS uses UTF-8 by default. Skipping."
    ;;
  linux | wsl)
    log "[locale] Ensuring UTF-8 locale (en_US.UTF-8)..."
    ensure_apt
    ensure_sudo

    pkg_update
    pkg_install locales

    sudo locale-gen en_US.UTF-8
    sudo update-locale LANG=en_US.UTF-8

    log "[locale] Done. You may need to restart the shell (exec zsh) or WSL."
    ;;
  *)
    die "[locale] Unsupported platform: ${PLATFORM:-unset}"
    ;;
  esac
}

locale_task "$@"
