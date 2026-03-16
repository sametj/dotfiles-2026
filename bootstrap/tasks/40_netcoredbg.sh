#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_netcoredbg_linux() {
  need_cmd curl
  need_cmd tar
  need_cmd find

  log "[netcoredbg] Installing .NET debugger on Linux/WSL..."

  local arch version url tmpdir install_dir binary

  arch="$(uname -m)"
  case "$arch" in
  x86_64 | amd64) arch="amd64" ;;
  aarch64 | arm64) arch="arm64" ;;
  *) die "[netcoredbg] Unsupported arch: $arch" ;;
  esac

  version="$(curl -fsSL https://api.github.com/repos/Samsung/netcoredbg/releases/latest |
    sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"

  [[ -n "$version" ]] || die "[netcoredbg] Could not determine latest version."

  url="https://github.com/Samsung/netcoredbg/releases/download/${version}/netcoredbg-linux-${arch}.tar.gz"

  tmpdir="$(mktemp -d)"
  install_dir="$HOME/.local/share/netcoredbg"

  rm -rf "$install_dir"
  mkdir -p "$install_dir"
  mkdir -p "$HOME/.local/bin"

  curl -fsSL "$url" -o "$tmpdir/netcoredbg.tar.gz"
  tar -xzf "$tmpdir/netcoredbg.tar.gz" -C "$install_dir"

  binary="$(find "$install_dir" -type f -name netcoredbg | head -n1)"
  [[ -n "$binary" ]] || die "[netcoredbg] Could not find netcoredbg binary."

  ln -sfn "$binary" "$HOME/.local/bin/netcoredbg"

  rm -rf "$tmpdir"

  log "[netcoredbg] Installed to $install_dir"
  "$HOME/.local/bin/netcoredbg" --version || true
}

netcoredbg_task() {
  ensure_supported_platform

  case "${PLATFORM:-}" in
  linux | wsl)
    if has_cmd netcoredbg; then
      log "[netcoredbg] Already installed."
      return
    fi

    install_netcoredbg_linux
    ;;
  macos)
    warn "[netcoredbg] Skipping on macOS for now."
    ;;
  *)
    die "[netcoredbg] Unsupported platform: ${PLATFORM:-unset}"
    ;;
  esac
}

netcoredbg_task "$@"
