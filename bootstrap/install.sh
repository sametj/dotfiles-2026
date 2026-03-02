#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/lib.sh"

main() {
  local root tasks_dir
  root="$(repo_root)"
  tasks_dir="$root/bootstrap/tasks"

  [[ -d "$tasks_dir" ]] || die "Tasks directory not found: $tasks_dir"

  log "Running all bootstrap tasks in: $tasks_dir"

  local task
  for task in "$tasks_dir"/*.sh; do
    [[ -f "$task" ]] || continue
    log "Running: $(basename "$task")"
    bash "$task"
  done
  log "Bootstrap complete."
  
  echo
  echo "Next steps:"
  echo "  - Start tmux: tmux"
  echo "  - If plugins didn't load, inside tmux press: Prefix + I"
  echo "  - Reload config: Prefix + r"
}

main "$@"
