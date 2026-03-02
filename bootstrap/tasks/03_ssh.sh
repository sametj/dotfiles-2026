#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

ssh_task() {
  log "[ssh] Setting up SSH for GitHub..."

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  local key="$HOME/.ssh/id_ed25519"

  # Generate key if it doesn't exist
  if [[ ! -f "$key" ]]; then
    log "[ssh] Generating ed25519 SSH key..."
    ssh-keygen -t ed25519 -C "$(git config --global user.email || echo 'github')" -f "$key" -N ""
  else
    log "[ssh] SSH key already exists."
  fi

  # Ensure ssh-agent running
  if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    log "[ssh] Starting ssh-agent..."
    eval "$(ssh-agent -s)"
  fi

  ssh-add "$key" >/dev/null 2>&1 || true

  # Add GitHub to known_hosts (prevents first-connection prompt)
  if ! grep -q github.com "$HOME/.ssh/known_hosts" 2>/dev/null; then
    log "[ssh] Adding github.com to known_hosts..."
    ssh-keyscan github.com >>"$HOME/.ssh/known_hosts" 2>/dev/null
  fi

  chmod 644 "$HOME/.ssh/known_hosts"

  log ""
  log "[ssh] Public key (add this to GitHub → Settings → SSH keys):"
  echo "------------------------------------------------------------"
  cat "${key}.pub"
  echo "------------------------------------------------------------"
  log ""

  log "[ssh] To test connection after adding key to GitHub:"
  log "       ssh -T git@github.com"
}

ssh_task "$@"
