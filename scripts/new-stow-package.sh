#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $0 <package-name> [target-path]

Create a new stow package that maps to config/<package-name>.

Arguments:
  package-name  Package name to create (example: ghostty)
  target-path   Path under HOME to link (default: .config/<package-name>)

Examples:
  $0 ghostty
  $0 wezterm .config/wezterm
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

pkg="${1:-}"
target_rel="${2:-}"

if [[ -z "$pkg" ]]; then
  usage
  exit 1
fi

if [[ -z "$target_rel" ]]; then
  target_rel=".config/$pkg"
fi

case "$target_rel" in
  /*)
    echo "target-path must be relative to HOME, not absolute: $target_rel" >&2
    exit 1
    ;;
  *".."*)
    echo "target-path must not contain '..': $target_rel" >&2
    exit 1
    ;;
esac

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$repo_root/config/$pkg"
link_path="$repo_root/stow/$pkg/$target_rel"

mkdir -p "$config_dir"
mkdir -p "$(dirname "$link_path")"

if [[ -e "$link_path" && ! -L "$link_path" ]]; then
  echo "Refusing to overwrite non-symlink path: $link_path" >&2
  exit 1
fi

rel_target="$({ python - <<PY
import os
print(os.path.relpath('$config_dir', os.path.dirname('$link_path')))
PY
} | tr -d '\n')"

ln -sfn "$rel_target" "$link_path"

echo "Created package '$pkg'"
echo "  config source: $config_dir"
echo "  stow mapping : $link_path -> $rel_target"
echo
echo "Next steps:"
echo "  1) Add your config files under: config/$pkg/"
echo "  2) Apply now: stow --dir stow --target \"\$HOME\" --restow $pkg"
echo "  3) Optional: add bootstrap/tasks/<order>_${pkg}.sh to call stow_package \"$pkg\""
