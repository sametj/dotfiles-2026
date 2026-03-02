# ----------------------------
# Functions
# ----------------------------

nr() {
  if [[ -z "${1:-}" ]]; then
    echo "❌ Usage: nr <npm-script> [args...]"
    return 1
  fi

  npm run "$1" -- "${@:2}" && clear
}
