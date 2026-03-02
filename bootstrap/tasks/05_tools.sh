#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_lazygit_release() {
  need_cmd curl
  need_cmd tar

  local arch os ver url tmpdir
  os="Linux"
  arch="$(uname -m)"
  case "$arch" in
  x86_64 | amd64) arch="x86_64" ;;
  aarch64 | arm64) arch="arm64" ;;
  *) die "[tools] Unsupported arch for lazygit: $(uname -m)" ;;
  esac

  log "[tools] Installing lazygit from GitHub releases..."

  ver="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    sed -n 's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p' | head -n 1)"

  [[ -n "$ver" ]] || die "[tools] Could not determine lazygit latest version."

  url="https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_${os}_${arch}.tar.gz"

  mkdir -p "$HOME/.local/bin"
  tmpdir="$(mktemp -d)"

  curl -fsSL "$url" -o "$tmpdir/lazygit.tar.gz"
  tar -xzf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit
  install -m 0755 "$tmpdir/lazygit" "$HOME/.local/bin/lazygit"

  rm -rf "$tmpdir"

  log "[tools] lazygit installed: $("$HOME/.local/bin/lazygit" --version 2>/dev/null || true)"
}

ensure_ubuntu_command_aliases() {
  # fd on Ubuntu is usually fdfind
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ensure_sudo
    sudo ln -sfn "$(command -v fdfind)" /usr/local/bin/fd
    log "[tools] Linked fd -> fdfind"
  fi

  # bat on Ubuntu is usually batcat
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ensure_sudo
    sudo ln -sfn "$(command -v batcat)" /usr/local/bin/bat
    log "[tools] Linked bat -> batcat"
  fi
}

tools_task() {
  log "[tools] Installing modern CLI tools + build deps..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y

  # Core stuff + build deps (treesitter parsers, native tooling)
  sudo apt-get install -y \
    git ca-certificates curl tar xz-utils unzip \
    build-essential gcc g++ make pkg-config \
    python3 python3-venv python3-pip

  # Modern CLI tools (some may fail depending on Ubuntu repo age)
  sudo apt-get install -y \
    fzf ripgrep fd-find bat zoxide git-delta || true

  # Optional: tree-sitter CLI (not required, but removes healthcheck warning if available)
  if ! command -v tree-sitter >/dev/null 2>&1; then
    sudo apt-get install -y tree-sitter-cli || true
  fi

  ensure_ubuntu_command_aliases

  # lazygit: try apt first, fallback to GitHub release
  if ! command -v lazygit >/dev/null 2>&1; then
    if sudo apt-get install -y lazygit; then
      log "[tools] lazygit installed via apt."
    else
      warn "[tools] lazygit not available via apt; installing from GitHub releases."
      install_lazygit_release
    fi
  else
    log "[tools] lazygit already installed."
  fi

  log "[tools] Done."
}

tools_task "$@"
