#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib.sh"

usage() {
  cat <<'USAGE'
Usage:
  ./bootstrap/install.sh [--list-apps] [--help]

Options:
  --list-apps   List manifest-driven apps under ./apps and exit.
  --help        Show this help text.
USAGE
}

list_apps_command() {
  local root apps_dir manifest app_name description

  root="$(repo_root)"
  apps_dir="$root/apps"

  if [[ ! -d "$apps_dir" ]]; then
    log "No apps directory found: $apps_dir"
    return 0
  fi

  log "Manifest-driven apps in: $apps_dir"

  local count=0
  shopt -s nullglob
  for manifest in "$apps_dir"/*/manifest.yaml; do
    app_name="$(manifest_field "$manifest" name)"
    description="$(manifest_field "$manifest" description)"

    printf '  - %s' "$app_name"
    if [[ -n "$description" ]]; then
      printf ' — %s' "$description"
    fi
    printf '\n'
    count=$((count + 1))
  done
  shopt -u nullglob

  if (( count == 0 )); then
    echo "  (none yet)"
    echo "  Hint: run scripts/add-app <name> to scaffold one."
  fi
}

run_all_tasks() {
  local root tasks_dir task
  local total=0
  local succeeded=0
  local failed=0
  local -a failed_tasks=()

  root="$(repo_root)"
  tasks_dir="$root/bootstrap/tasks"

  [[ -d "$tasks_dir" ]] || die "Tasks directory not found: $tasks_dir"

  ensure_supported_platform

  case "$PLATFORM" in
    macos)
      ensure_brew
      setup_brew_shellenv
      ;;
    linux|wsl)
      ensure_sudo
      ensure_apt
      ;;
    *)
      die "Unsupported platform: $PLATFORM"
      ;;
  esac

  log "Running all bootstrap tasks in: $tasks_dir"

  for task in "$tasks_dir"/*.sh; do
    [[ -f "$task" ]] || continue
    total=$((total + 1))

    log "Running: $(basename "$task")"
    if bash "$task"; then
      succeeded=$((succeeded + 1))
    else
      failed=$((failed + 1))
      failed_tasks+=("$(basename "$task")")
      warn "Task failed: $(basename "$task")"
    fi
  done

  echo
  log "Bootstrap summary: total=${total}, succeeded=${succeeded}, failed=${failed}"
  if (( failed > 0 )); then
    warn "Failed tasks: ${failed_tasks[*]}"
    die "Bootstrap completed with failures."
  fi

  log "Bootstrap complete."

  echo
  echo "Next steps:"
  echo "  - Start tmux: tmux"
  echo "  - If plugins didn't load, inside tmux press: Prefix + I"
  echo "  - Reload config: Prefix + r"

  case "$PLATFORM" in
    macos)
      echo "  - Restart your terminal if brew-installed binaries are missing from PATH"
      ;;
  esac
}

main() {
  case "${1:-}" in
    --list-apps)
      list_apps_command
      ;;
    --help|-h)
      usage
      ;;
    "")
      run_all_tasks
      ;;
    *)
      usage
      die "Unknown option: $1"
      ;;
  esac
}

main "$@"
