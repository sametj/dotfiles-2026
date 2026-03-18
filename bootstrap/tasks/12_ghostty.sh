#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

log "[ghostty] Linking Ghostty config..."
root="$(repo_root)"
safe_symlink "$root/config/ghostty" "$HOME/.config/ghostty"
