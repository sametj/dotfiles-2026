#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_lazygit_release_linux() {
  need_cmd curl
  need_cmd tar

  local arch ver url tmpdir
  arch="$(uname -m)"

  case "$arch" in
    x86_64|amd64) arch="x86_64" ;;
    aarch64|arm64) arch="arm64" ;;
    *) die "[tools] Unsupported arch for lazygit: $(uname -m)" ;;
  esac

  log "[tools] Installing lazygit from GitHub releases..."

  ver="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | sed -n 's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p' \
    | head -n 1)"

  [[ -n "$ver" ]] || die "[tools] Could not determine lazygit latest version."

  url="https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_${arch}.tar.gz"

  mkdir -p "$HOME/.local/bin"
  tmpdir="$(mktemp -d)"

  curl -fsSL "$url" -o "$tmpdir/lazygit.tar.gz"
  tar -xzf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit
  install -m 0755 "$tmpdir/lazygit" "$HOME/.local/bin/lazygit"

  rm -rf "$tmpdir"

  log "[tools] lazygit installed: $("$HOME/.local/bin/lazygit" --version 2>/dev/null || true)"
}

ensure_linux_command_aliases() {
  mkdir -p "$HOME/.local/bin"

  # fd on Ubuntu is usually fdfind
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log "[tools] Linked fd -> fdfind in ~/.local/bin"
  fi

  # bat on Ubuntu is usually batcat
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
    log "[tools] Linked bat -> batcat in ~/.local/bin"
  fi
}

install_macos_tools() {
  ensure_brew
  setup_brew_shellenv

  log "[tools] Installing modern CLI tools on macOS..."

  pkg_install \
    ca-certificates \
    curl \
    unzip \
    fzf \
    ripgrep \
    fd \
    bat \
    zoxide \
    git-delta \
    lazygit

  if ! has_cmd tree-sitter; then
    brew install tree-sitter || true
  fi
}

install_linux_tools() {
  ensure_apt
  ensure_sudo

  log "[tools] Installing modern CLI tools + build deps on Linux/WSL..."

  pkg_update

  pkg_install \
    git \
    ca-certificates \
    curl \
    tar \
    xz-utils \
    unzip \
    build-essential \
    gcc \
    g++ \
    make \
    pkg-config \
    python3 \
    python3-venv \
    python3-pip

  sudo apt-get install -y \
    fzf \
    ripgrep \
    fd-find \
    bat \
    zoxide \
    git-delta || true

  if ! command -v tree-sitter >/dev/null 2>&1; then
    sudo apt-get install -y tree-sitter-cli || true
  fi

  ensure_linux_command_aliases

  if ! command -v lazygit >/dev/null 2>&1; then
    if sudo apt-get install -y lazygit; then
      log "[tools] lazygit installed via apt."
    else
      warn "[tools] lazygit not available via apt; installing from GitHub releases."
      install_lazygit_release_linux
    fi
  else
    log "[tools] lazygit already installed."
  fi
}

tools_task() {
  case "${PLATFORM:-}" in
    macos)
      install_macos_tools
      ;;
    linux|wsl)
      install_linux_tools
      ;;
    *)
      die "[tools] Unsupported platform: ${PLATFORM:-unset}"
      ;;
  esac

  log "[tools] Done."
}

tools_task "$@"
