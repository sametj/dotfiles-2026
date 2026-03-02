#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

git_task() {
  log "[git] Installing and configuring git..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y git

  local root
  root="$(repo_root)"

  # Symlink gitconfig
  safe_symlink "$root/config/git/gitconfig" "$HOME/.gitconfig"

  # Symlink global gitignore
  mkdir -p "$HOME/.config/git"
  safe_symlink "$root/config/git/gitignore_global" "$HOME/.config/git/gitignore_global"

  # Create local config (private, not in repo)
  local local_cfg="$HOME/.gitconfig.local"
  if [[ ! -f "$local_cfg" ]]; then
    warn "[git] Creating $local_cfg (private settings go here)"
    cat > "$local_cfg" <<'EOF'
# ~/.gitconfig.local (NOT in dotfiles repo)
# Put machine-specific or private settings here.

[user]
    email = you@example.com

# Example: if you want different identity for work repos later:
# [includeIf "gitdir:~/work/"]
#     path = ~/.gitconfig.work
EOF
  else
    log "[git] $local_cfg already exists; leaving it untouched."
  fi

  log "[git] Done."
}

git_task "$@"
