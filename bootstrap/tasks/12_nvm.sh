#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

append_if_missing() {
  local line="$1"
  local file="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -Fqx "$line" "$file" 2>/dev/null || echo "$line" >>"$file"
}

nvm_task() {
  log "[nvm] Installing nvm + Node LTS..."

  ensure_apt
  ensure_sudo
  sudo apt-get update -y
  sudo apt-get install -y curl ca-certificates git

  # Install nvm (idempotent)
  if [[ ! -d "$HOME/.nvm" ]]; then
    log "[nvm] Cloning nvm..."
    git clone https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
  else
    log "[nvm] nvm already exists, updating..."
    git -C "$HOME/.nvm" fetch --tags --quiet
    git -C "$HOME/.nvm" pull --ff-only --quiet || true
  fi

  # Load nvm in this script
  # shellcheck disable=SC1090
  source "$HOME/.nvm/nvm.sh"

  # Install + set LTS
  log "[nvm] Installing Node LTS..."
  nvm install --lts
  nvm alias default 'lts/*'
  nvm use default

  # Ensure zsh loads nvm (your repo uses config/shell/zsh/conf.d)
  local confdir="$HOME/dotfiles/config/shell/zsh/conf.d"
  local nvm_conf="$confdir/45-nvm.zsh"
  mkdir -p "$confdir"

  cat >"$nvm_conf" <<'ZSH'
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Ensure "default" node is active in non-interactive shells too (scripts, tmux hooks, etc.)
if command -v nvm >/dev/null 2>&1; then
  nvm use --silent default >/dev/null 2>&1 || true
fi
ZSH

  log "[nvm] Wrote: $nvm_conf"

  # Quick verification
  log "[nvm] node: $(node -v)"
  log "[nvm] npm:  $(npm -v)"
}

nvm_task "$@"
