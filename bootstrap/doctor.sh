#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib.sh"

main() {
  local root
  root="$(repo_root)"
  local status=0

  declare -A expected_links=(
    ["$HOME/.gitconfig"]="$root/config/git/gitconfig"
    ["$HOME/.config/git/gitignore_global"]="$root/config/git/gitignore_global"
    ["$HOME/.config/tmux"]="$root/config/tmux"
    ["$HOME/.tmux.conf"]="$root/config/tmux/tmux.conf"
    ["$HOME/.zshrc"]="$root/config/shell/zsh/zshrc"
    ["$HOME/.config/nvim"]="$root/config/nvim"
    ["$HOME/.config/ghostty"]="$root/config/ghostty"
  )

  for link in "${!expected_links[@]}"; do
    expected_target="${expected_links[$link]}"

    if [[ ! -e "$link" && ! -L "$link" ]]; then
      warn "[doctor] Missing symlink: $link -> $expected_target"
      status=1
    elif [[ ! -L "$link" ]]; then
      warn "[doctor] Expected symlink but found regular file: $link"
      status=1
    else
      actual_target="$(readlink "$link")"
      if [[ "$actual_target" != "$expected_target" ]]; then
        warn "[doctor] Wrong target: $link -> $actual_target (expected $expected_target)"
        status=1
      elif [[ ! -e "$link" ]]; then
        warn "[doctor] Broken symlink: $link -> $actual_target"
        status=1
      else
        log "[doctor] OK: $link -> $actual_target"
      fi
    fi
  done

  if (( status == 0 )); then
    log "Doctor checks passed."
  else
    die "Doctor checks failed."
  fi
}

main "$@"
