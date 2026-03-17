#!/usr/bin/env bash
set -euo pipefail

log()  { printf "\n\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m!!\033[0m %s\n" "$*"; }
die()  { printf "\n\033[1;31mxx\033[0m %s\n" "$*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }
has_cmd() { command -v "$1" >/dev/null 2>&1; }

need_stow() {
  has_cmd stow || die "Missing command: stow"
}

retry() {
  # retry <attempts> <delay_seconds> <command...>
  local attempts="$1"
  local delay="$2"
  shift 2

  local i
  for ((i = 1; i <= attempts; i++)); do
    if "$@"; then
      return 0
    fi

    if (( i < attempts )); then
      warn "Command failed (attempt ${i}/${attempts}); retrying in ${delay}s: $*"
      sleep "$delay"
    fi
  done

  return 1
}

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

detect_platform() {
  case "$(uname -s)" in
    Darwin)
      PLATFORM="macos"
      ;;
    Linux)
      if is_wsl; then
        PLATFORM="wsl"
      else
        PLATFORM="linux"
      fi
      ;;
    *)
      PLATFORM="unknown"
      ;;
  esac

  export PLATFORM
}

ensure_supported_platform() {
  detect_platform

  case "$PLATFORM" in
    macos|linux|wsl)
      log "Detected platform: $PLATFORM"
      ;;
    *)
      die "Unsupported platform: $(uname -s)"
      ;;
  esac
}

ensure_sudo() {
  need_cmd sudo
  sudo -v
}

ensure_apt() {
  has_cmd apt || die "apt not found. This step requires Debian/Ubuntu."
}

ensure_brew() {
  if has_cmd brew; then
    return
  fi

  log "Homebrew not found. Installing Homebrew..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  setup_brew_shellenv

  has_cmd brew || die "Homebrew installation completed, but brew is still not available in PATH."
}

setup_brew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

safe_symlink() {
  # safe_symlink <source> <dest>
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    if [[ "$(readlink "$dest")" == "$src" ]]; then
      log "Link already OK: $dest -> $src"
      return
    fi
    warn "Replacing existing symlink: $dest"
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    warn "Backing up existing file: $dest -> $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  log "Linked: $dest -> $src"
}

stow_package() {
  # stow_package <package>
  local package="$1"
  local root stow_dir
  root="$(repo_root)"
  stow_dir="$root/stow"

  need_stow
  [[ -d "$stow_dir/$package" ]] || die "Stow package not found: $stow_dir/$package"

  log "Stowing package: $package"
  stow --dir "$stow_dir" --target "$HOME" --restow "$package"
}

pkg_update() {
  case "${PLATFORM:-}" in
    macos)
      setup_brew_shellenv
      brew update
      ;;
    linux|wsl)
      ensure_sudo
      ensure_apt
      sudo apt-get update -y
      ;;
    *)
      die "pkg_update called before platform was initialized"
      ;;
  esac
}

pkg_install() {
  case "${PLATFORM:-}" in
    macos)
      setup_brew_shellenv
      brew install "$@"
      ;;
    linux|wsl)
      ensure_sudo
      ensure_apt
      sudo apt-get install -y "$@"
      ;;
    *)
      die "pkg_install called before platform was initialized"
      ;;
  esac
}

pkg_install_cask() {
  case "${PLATFORM:-}" in
    macos)
      setup_brew_shellenv
      brew install --cask "$@"
      ;;
    *)
      die "pkg_install_cask is only supported on macOS"
      ;;
  esac
}
