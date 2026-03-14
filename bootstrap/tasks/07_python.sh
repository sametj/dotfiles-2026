#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

ensure_pipx_available() {
  if has_cmd pipx; then
    log "[python] pipx already installed: $(command -v pipx)"
    return
  fi

  case "${PLATFORM:-}" in
    macos)
      ensure_brew
      setup_brew_shellenv
      pkg_install pipx
      ;;
    linux|wsl)
      ensure_apt
      ensure_sudo
      pkg_install pipx
      ;;
    *)
      die "[python] Unsupported platform: ${PLATFORM:-unset}"
      ;;
  esac
}

python_cli_task() {
  log "[python] Installing pipx + Python CLI tools..."

  case "${PLATFORM:-}" in
    macos)
      ensure_brew
      setup_brew_shellenv

      if ! has_cmd python3; then
        pkg_install python
      else
        log "[python] python3 already installed: $(command -v python3)"
      fi
      ;;
    linux|wsl)
      ensure_apt
      ensure_sudo
      pkg_update
      pkg_install python3 python3-venv python3-pip
      ;;
    *)
      die "[python] Unsupported platform: ${PLATFORM:-unset}"
      ;;
  esac

  ensure_pipx_available

  pipx ensurepath || true

  if ! has_cmd black; then
    pipx install black
  else
    log "[python] black already installed: $(command -v black)"
  fi

  log "[python] Done."
}

python_cli_task "$@"
