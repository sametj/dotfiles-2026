#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

NVIM_VERSION="0.11.6"

nvim_task() {
  log "[nvim] Installing Neovim"

  case "${PLATFORM:-}" in
    macos)
      ensure_brew
      setup_brew_shellenv

      if has_cmd nvim; then
        log "[nvim] Neovim already installed: $(command -v nvim)"
        nvim --version | head -n 2 || true
        return
      fi

      pkg_install neovim
      ;;

    linux|wsl)
      ensure_apt
      ensure_sudo

      if has_cmd nvim; then
        log "[nvim] Neovim already installed: $(command -v nvim)"
        nvim --version | head -n 2 || true
        return
      fi

      pkg_update
      pkg_install curl tar

      local arch url tmp extract_dir install_dir
      arch="$(uname -m)"

      case "$arch" in
        x86_64|amd64)
          url="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
          extract_dir="nvim-linux-x86_64"
          ;;
        aarch64|arm64)
          url="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-arm64.tar.gz"
          extract_dir="nvim-linux-arm64"
          ;;
        *)
          die "[nvim] Unsupported Linux architecture: $arch"
          ;;
      esac

      tmp="/tmp/${extract_dir}.tar.gz"
      install_dir="/opt/nvim-${NVIM_VERSION}"

      log "[nvim] Downloading ${url}"
      curl -fL -o "$tmp" "$url"

      sudo rm -rf "$install_dir"
      sudo tar -C /opt -xzf "$tmp"
      sudo mv "/opt/${extract_dir}" "$install_dir"
      sudo ln -sfn "$install_dir" /opt/nvim

      log "[nvim] Installed to /opt/nvim"
      /opt/nvim/bin/nvim --version | head -n 2 || true
      ;;

    *)
      die "[nvim] Unsupported platform: ${PLATFORM:-unset}"
      ;;
  esac
}

nvim_task "$@"
