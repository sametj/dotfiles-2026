#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib.sh"

main() {
  local root stow_dir pkg
  local -a packages=()
  local status=0

  root="$(repo_root)"
  stow_dir="$root/stow"

  need_stow

  while IFS= read -r pkg; do
    [[ -n "$pkg" ]] && packages+=("$pkg")
  done < <(list_stow_packages "$stow_dir")

  if (( ${#packages[@]} == 0 )); then
    warn "No stow packages found in $stow_dir"
    exit 0
  fi

  log "Found stow packages: ${packages[*]}"

  for pkg in "${packages[@]}"; do
    local pkg_dir="$stow_dir/$pkg"
    log "[doctor] Checking package: $pkg"

    if find "$pkg_dir" -type l | grep -q .; then
      while IFS= read -r link; do
        if [[ ! -e "$link" ]]; then
          warn "[doctor] Broken symlink in package '$pkg': $link"
          status=1
        fi
      done < <(find "$pkg_dir" -type l)
    fi

    if stow --dir "$stow_dir" --target "$HOME" --restow --no "$pkg" >/dev/null; then
      log "[doctor] stow dry-run OK: $pkg"
    else
      warn "[doctor] stow dry-run failed: $pkg"
      status=1
    fi
  done

  if (( status == 0 )); then
    log "Doctor checks passed."
  else
    die "Doctor checks failed."
  fi
}

main "$@"
