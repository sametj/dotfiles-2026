#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib.sh"

remove_if_symlink() {
  local target="$1"

  if [[ -L "$target" ]]; then
    log "Removing symlink: $target"
    rm "$target"
  fi
}

unlink_app_files() {
  local app="$1"
  local files_dir src rel dest

  files_dir="$(app_files_dir "$app")"
  [[ -d "$files_dir" ]] || return 0

  while IFS= read -r -d '' src; do
    rel="${src#"$files_dir"/}"
    [[ "$rel" == ".gitkeep" ]] && continue
    [[ -d "$src" ]] && continue

    dest="$HOME/$rel"
    remove_if_symlink "$dest"
  done < <(find "$files_dir" -mindepth 1 -print0)
}

log "Removing dotfiles symlinks..."

unlink_app_files git
unlink_app_files zsh
unlink_app_files tmux
unlink_app_files nvim
unlink_app_files ghostty

log "Removing tmux plugins..."

rm -rf "$HOME/.tmux/plugins"
rm -rf "$HOME/.local/share/tmux/plugins"

log "Removing netcoredbg..."

rm -rf "$HOME/.local/share/netcoredbg"
rm -f "$HOME/.local/bin/netcoredbg"

log "Removing optional tools..."

rm -f "$HOME/.local/bin/lazygit"
rm -f "$HOME/.local/bin/yazi"
rm -f "$HOME/.local/bin/ya"

log "Removing nvm (optional)..."

if [[ -d "$HOME/.nvm" ]]; then
  read -rp "Remove nvm? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.nvm"
  fi
fi

log "Uninstall complete."
