#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_starship() {
  if has_cmd starship; then
    log "[zsh] starship already installed: $(command -v starship)"
    return
  fi

  case "${PLATFORM:-}" in
  macos)
    log "[zsh] Installing starship via Homebrew..."
    pkg_install starship
    ;;
  linux | wsl)
    log "[zsh] Installing starship..."
    if sudo apt-get install -y starship; then
      log "[zsh] starship installed via apt"
    else
      warn "[zsh] starship not available via apt; using official install script"
      need_cmd curl
      retry 3 2 sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    fi
    ;;
  *)
    die "[zsh] Unsupported platform for starship install: ${PLATFORM:-unset}"
    ;;
  esac
}

symlink_zshrc() {
  log "[zsh] Linking zsh app files"
  link_app_files "zsh"
}

set_default_shell_zsh() {
  if has_cmd zsh; then
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
      log "[zsh] Setting default shell to zsh ($zsh_path)..."
      chsh -s "$zsh_path" || warn "[zsh] chsh failed (not fatal)."
    else
      log "[zsh] Default shell already zsh."
    fi
  fi
}

main() {
  ensure_supported_platform

  log "[zsh] Configuring zsh + starship..."

  has_cmd zsh || die "[zsh] zsh is required but not installed."
  has_cmd git || die "[zsh] git is required but not installed."
  has_cmd curl || die "[zsh] curl is required but not installed."

  install_starship
  symlink_zshrc
  set_default_shell_zsh

  log "[zsh] Done. Restart your terminal or run: exec zsh"
}

main "$@"
