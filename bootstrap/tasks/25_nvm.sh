#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

nvm_task() {
  log "[nvm] Installing nvm + Node LTS + pnpm..."

  has_cmd curl || die "[nvm] curl is required but not installed."
  has_cmd git || die "[nvm] git is required but not installed."

  if [[ ! -d "$HOME/.nvm" ]]; then
    log "[nvm] Cloning nvm..."
    git clone https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
  else
    log "[nvm] nvm already exists."
  fi

  # shellcheck disable=SC1090
  source "$HOME/.nvm/nvm.sh"

  log "[nvm] Installing Node LTS..."
  nvm install --lts
  nvm alias default 'lts/*'
  nvm use default

  if command -v corepack >/dev/null 2>&1; then
    log "[nvm] Enabling corepack..."
    corepack enable
    corepack prepare pnpm@latest --activate
  else
    warn "[nvm] corepack not found; falling back to npm global install for pnpm..."
    npm install -g pnpm
  fi

  local root confdir nvm_conf
  root="$(repo_root)"
  confdir="$root/config/shell/zsh/conf.d"
  nvm_conf="$confdir/45-nvm.zsh"

  mkdir -p "$confdir"

  cat >"$nvm_conf" <<'ZSH'
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

if command -v nvm >/dev/null 2>&1; then
  nvm use --silent default >/dev/null 2>&1 || true
fi
ZSH

  log "[nvm] node: $(node -v)"
  log "[nvm] npm:  $(npm -v)"
  log "[nvm] pnpm: $(pnpm -v)"
}

nvm_task "$@"
