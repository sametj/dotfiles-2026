#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

nvm_latest_tag() {
  need_cmd git

  local latest_tag
  latest_tag="$(git ls-remote --tags --refs https://github.com/nvm-sh/nvm.git 'v[0-9]*' | awk -F/ '{print $3}' | sort -V | tail -n1)"

  [[ -n "$latest_tag" ]] || die "[nvm] Could not determine latest nvm tag from upstream."

  printf '%s
' "$latest_tag"
}

nvm_task() {
  log "[nvm] Installing nvm + Node LTS + pnpm..."

  has_cmd curl || die "[nvm] curl is required but not installed."
  has_cmd git || die "[nvm] git is required but not installed."

  local latest_tag
  latest_tag="$(nvm_latest_tag)"
  log "[nvm] Latest upstream version: ${latest_tag}"

  if [[ ! -d "$HOME/.nvm/.git" ]]; then
    log "[nvm] Cloning nvm ${latest_tag}..."
    git clone --branch "$latest_tag" --depth 1 https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
  else
    log "[nvm] Updating existing nvm checkout to ${latest_tag}..."
    git -C "$HOME/.nvm" fetch --tags --force origin
    git -C "$HOME/.nvm" checkout --force "$latest_tag"
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
  confdir="$root/apps/zsh/files/.config/zsh/conf.d"
  nvm_conf="$confdir/45-node.zsh"

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
