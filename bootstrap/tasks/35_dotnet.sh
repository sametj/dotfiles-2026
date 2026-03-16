#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_dotnet_linux() {
  ensure_apt
  ensure_sudo

  log "[dotnet] Installing .NET SDK on Linux/WSL..."

  pkg_update
  pkg_install wget apt-transport-https software-properties-common

  if [[ ! -f /etc/apt/sources.list.d/microsoft-prod.list ]]; then
    need_cmd wget
    need_cmd dpkg
    need_cmd lsb_release

    log "[dotnet] Adding Microsoft package repository..."
    wget "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb
    rm -f /tmp/packages-microsoft-prod.deb
  else
    log "[dotnet] Microsoft package repository already configured."
  fi

  pkg_update

  if sudo apt-get install -y dotnet-sdk-10.0; then
    log "[dotnet] Installed dotnet-sdk-10.0"
  elif sudo apt-get install -y dotnet-sdk-9.0; then
    warn "[dotnet] dotnet-sdk-10.0 unavailable; installed dotnet-sdk-9.0 instead"
  elif sudo apt-get install -y dotnet-sdk-8.0; then
    warn "[dotnet] dotnet-sdk-10.0/9.0 unavailable; installed dotnet-sdk-8.0 instead"
  else
    warn "[dotnet] Failed to install .NET SDK via apt. Check Microsoft repo and Ubuntu version compatibility."
  fi
}

install_dotnet_macos() {
  ensure_brew
  setup_brew_shellenv

  log "[dotnet] Installing .NET SDK on macOS..."

  if ! has_cmd dotnet; then
    pkg_install_cask dotnet-sdk
  else
    log "[dotnet] dotnet already installed: $(command -v dotnet)"
  fi
}

dotnet_task() {
  ensure_supported_platform

  case "${PLATFORM:-}" in
  macos)
    install_dotnet_macos
    ;;
  linux | wsl)
    install_dotnet_linux
    ;;
  *)
    die "[dotnet] Unsupported platform: ${PLATFORM:-unset}"
    ;;
  esac

  log "[dotnet] Installed versions:"
  dotnet --list-sdks || true
}

dotnet_task "$@"
