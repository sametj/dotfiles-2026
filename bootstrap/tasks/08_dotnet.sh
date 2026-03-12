#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

dotnet_task() {
  log "[dotnet] Installing .NET SDK..."

  ensure_apt
  ensure_sudo

  sudo apt-get update -y
  sudo apt-get install -y wget apt-transport-https software-properties-common

  # Add Microsoft package repository
  if [[ ! -f /etc/apt/sources.list.d/microsoft-prod.list ]]; then
    log "[dotnet] Adding Microsoft package repository..."
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
  fi

  sudo apt-get update -y

  # Install .NET 10 SDK
  sudo apt-get install -y dotnet-sdk-10.0 || true

  log "[dotnet] Installed versions:"
  dotnet --list-sdks || true
}

dotnet_task "$@"
