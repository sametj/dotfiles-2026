#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

tmux_task() {
  log "[tmux] Installing tmux + TPM and linking config..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y tmux git

  local root
  root="$(repo_root)"

  # Link tmux.conf
  safe_symlink "$root/config/tmux/tmux.conf" "$HOME/.tmux.conf"

  # Install TPM if missing
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "[tmux] Installing TPM..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    log "[tmux] TPM already installed."
  fi

  # Clone catppuccin plugin (pinned)
  local plugin_dir="$HOME/.config/tmux/plugins/catppuccin/tmux"
  if [[ ! -d "$plugin_dir/.git" ]]; then
    log "[tmux] Cloning catppuccin/tmux v2.1.3..."
    mkdir -p "$HOME/.config/tmux/plugins/catppuccin"
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$plugin_dir"
  else
    log "[tmux] catppuccin already present."
  fi

  log "[tmux] Done."
  log "[tmux] Next: start tmux, then press prefix + I to install plugins."
}

tmux_task "$@"
