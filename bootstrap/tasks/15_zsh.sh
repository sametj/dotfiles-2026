#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_oh_my_zsh() {
  # Install OMZ only if missing
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "[zsh] Installing Oh My Zsh..."
    # official unattended install
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
  # install_omz_plugin <name> <git_url>
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
  local root
  root="$(repo_root)"

  # repo-managed zshrc path
  local src="$root/config/shell/zsh/zshrc"
  [[ -f "$src" ]] || die "[zsh] Missing repo zshrc at: $src"

  log "[zsh] Linking ~/.zshrc -> repo zshrc"
  safe_symlink "$src" "$HOME/.zshrc"
}

set_default_shell_zsh() {
  # Optional: sets login shell to zsh
  # Comment out if you don't want it.
  if command -v zsh >/dev/null 2>&1; then
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
  log "[zsh] Installing zsh + dependencies..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y zsh git curl ca-certificates

  install_oh_my_zsh
  install_p10k

  install_omz_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  install_omz_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  symlink_zshrc
  set_default_shell_zsh

  log "[zsh] Done. Restart your terminal or run: exec zsh"
}

main "$@"
