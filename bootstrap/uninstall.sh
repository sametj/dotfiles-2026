#!/usr/bin/env bash
set -euo pipefail

log() {
  printf "\n\033[1;33m==>\033[0m %s\n" "$*"
}

remove_if_symlink() {
  local target="$1"

  if [[ -L "$target" ]]; then
    log "Removing symlink: $target"
    rm "$target"
  fi
}

log "Removing dotfiles symlinks..."

remove_if_symlink "$HOME/.zshrc"
remove_if_symlink "$HOME/.tmux.conf"
remove_if_symlink "$HOME/.gitconfig"

if [[ -L "$HOME/.config/git/gitignore_global" ]]; then
  rm "$HOME/.config/git/gitignore_global"
fi

log "Removing tmux plugins..."

rm -rf "$HOME/.tmux/plugins"

log "Removing netcoredbg..."

rm -rf "$HOME/.local/share/netcoredbg"
rm -f "$HOME/.local/bin/netcoredbg"

log "Removing optional tools..."

rm -f "$HOME/.local/bin/lazygit"
rm -f "$HOME/.local/bin/yazi"
rm -f "$HOME/.local/bin/ya"

log "Removing Oh My Zsh (optional)..."

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  read -rp "Remove Oh My Zsh? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.oh-my-zsh"
  fi
fi

log "Removing nvm (optional)..."

if [[ -d "$HOME/.nvm" ]]; then
  read -rp "Remove nvm? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.nvm"
  fi
fi

log "Uninstall complete."
