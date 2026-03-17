#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

log "[ghostty] Stowing Ghostty config..."
stow_package "ghostty"
