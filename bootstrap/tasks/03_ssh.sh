#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

ssh_task() {
  log "[ssh] Setting up SSH for GitHub..."

  need_cmd ssh-keygen
  need_cmd ssh-agent
  need_cmd ssh-add
  need_cmd ssh-keyscan
  need_cmd git

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  local key="$HOME/.ssh/id_ed25519"
  local known_hosts="$HOME/.ssh/known_hosts"

  if [[ ! -f "$key" ]]; then
    log "[ssh] Generating ed25519 SSH key..."
    ssh-keygen -t ed25519 -C "$(git config --global user.email || echo 'github')" -f "$key" -N ""
  else
    log "[ssh] SSH key already exists."
  fi

  if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    log "[ssh] Starting ssh-agent..."
    eval "$(ssh-agent -s)"
  fi

  ssh-add "$key" >/dev/null 2>&1 || true

  touch "$known_hosts"
  if ! grep -q "github.com" "$known_hosts" 2>/dev/null; then
    log "[ssh] Adding github.com to known_hosts..."
    ssh-keyscan github.com >>"$known_hosts" 2>/dev/null
    warn "[ssh] Verify GitHub host fingerprints: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints"
  fi

  chmod 644 "$known_hosts"

  log "[ssh] Public key (add this to GitHub → Settings → SSH keys):"
  echo "------------------------------------------------------------"
  cat "${key}.pub"
  echo "------------------------------------------------------------"

  log "[ssh] To test connection after adding key to GitHub:"
  log "       ssh -T git@github.com"
}

ssh_task "$@"
