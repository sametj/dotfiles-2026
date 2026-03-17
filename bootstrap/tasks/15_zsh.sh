#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "[zsh] Installing Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    log "[zsh] Oh My Zsh already installed."
  fi
}

install_p10k() {
  local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ ! -d "$p10k_dir" ]]; then
    log "[zsh] Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
  else
    log "[zsh] powerlevel10k already installed."
  fi
}

install_omz_plugin() {
  local name="$1"
  local url="$2"
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

  if [[ ! -d "$dir" ]]; then
    log "[zsh] Installing OMZ plugin: $name"
    git clone --depth=1 "$url" "$dir"
  else
    log "[zsh] OMZ plugin already installed: $name"
  fi
}

symlink_zshrc() {
  log "[zsh] Stowing ~/.zshrc"
  stow_package "zsh"
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
  log "[zsh] Configuring zsh..."

  has_cmd zsh || die "[zsh] zsh is required but not installed."
  has_cmd git || die "[zsh] git is required but not installed."
  has_cmd curl || die "[zsh] curl is required but not installed."

  install_oh_my_zsh
  install_p10k

  install_omz_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  install_omz_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  symlink_zshrc
  set_default_shell_zsh

  log "[zsh] Done. Restart your terminal or run: exec zsh"
}

main "$@"
