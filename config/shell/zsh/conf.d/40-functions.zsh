# ------------------------------
# Functions
# ------------------------------

nr() {
  if [[ -z "${1:-}" ]]; then
    echo "Usage: nr <npm-script> [args...]"
    return 1
  fi

  local script="$1"
  shift

  npm run "$script" -- "$@" && clear
}
