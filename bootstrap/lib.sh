#!/usr/bin/env bash
set -euo pipefail

log()  { printf "\n\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m!!\033[0m %s\n" "$*"; }
die()  { printf "\n\033[1;31mxx\033[0m %s\n" "$*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }

is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }

ensure_sudo() {
  need_cmd sudo
  sudo -v
}

ensure_apt() {
  command -v apt >/dev/null 2>&1 || die "This installer currently supports Debian/Ubuntu (apt)."
}

repo_root() {
  # directory of this script's parent (bootstrap/)
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

safe_symlink() {
  # safe_symlink <source> <dest>
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    # if already correct symlink, do nothing
    if [[ "$(readlink "$dest")" == "$src" ]]; then
      log "Link already OK: $dest -> $src"
      return
    fi
    warn "Replacing existing symlink: $dest"
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    warn "Backing up existing file: $dest -> $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  log "Linked: $dest -> $src"
}
