#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

tmux_task() {
  log "[tmux] Linking config and installing plugins..."

  has_cmd tmux || die "[tmux] tmux is required but not installed."
  has_cmd git || die "[tmux] git is required but not installed."

  local root
  root="$(repo_root)"
  safe_symlink "$root/config/tmux" "$HOME/.config/tmux"
  safe_symlink "$root/config/tmux/tmux.conf" "$HOME/.tmux.conf"

  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "[tmux] Installing TPM..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    log "[tmux] TPM already installed."
  fi

  local plugin_dir="$HOME/.local/share/tmux/plugins/catppuccin/tmux"
  if [[ ! -d "$plugin_dir/.git" ]]; then
    log "[tmux] Cloning catppuccin/tmux v2.1.3..."
    mkdir -p "$HOME/.local/share/tmux/plugins/catppuccin"
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$plugin_dir"
  else
    log "[tmux] catppuccin already present."
  fi

  log "[tmux] Done."
  log "[tmux] Next: start tmux, then press prefix + I to install plugins."
}

tmux_task "$@"
