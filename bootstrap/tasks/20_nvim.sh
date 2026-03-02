#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

NVIM_VERSION="0.11.6"

nvim_task() {
  log "[nvim] Installing Neovim v${NVIM_VERSION} to /opt..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y curl tar

  local url="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
  local tmp="/tmp/nvim-linux-x86_64.tar.gz"

  curl -fL -o "$tmp" "$url"

  sudo rm -rf "/opt/nvim-${NVIM_VERSION}"
  sudo tar -C /opt -xzf "$tmp"
  sudo mv /opt/nvim-linux-x86_64 "/opt/nvim-${NVIM_VERSION}"

  # Stable symlink
  sudo ln -sfn "/opt/nvim-${NVIM_VERSION}" /opt/nvim

  log "[nvim] Installed to /opt/nvim"

  /opt/nvim/bin/nvim --version | head -n 2 || true
}

nvim_task "$@"
