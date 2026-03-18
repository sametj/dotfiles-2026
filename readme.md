# 📦 TJ Dotfiles

Personal development environment setup for Linux, WSL, and macOS.

This repo is now organized around **apps**. Each app owns:

- a `manifest.yaml`
- tracked files under `files/`
- optional app-specific helper scripts under `hooks/`

The bootstrap layer installs packages and links app files into `$HOME`.

## Repo Layout

```text
.
├── apps/               # App-oriented source of truth
│   ├── git/
│   ├── ghostty/
│   ├── nvim/
│   ├── tmux/
│   └── zsh/
├── bootstrap/          # Installer logic and tasks
├── docs/               # Architecture and contributor docs
└── scripts/            # Small helper scripts
```

## Quick Start

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap/install.sh
```

## Current Migrated Apps

- `git`
- `ghostty`
- `nvim`
- `tmux`
- `zsh`

List app manifests:

```bash
./bootstrap/install.sh --list-apps
```

Scaffold a new app:

```bash
scripts/add-app wezterm
```

## How Linking Works

Each app's `files/` directory mirrors the final layout under `$HOME`.

Examples:

- `apps/git/files/.gitconfig` → `~/.gitconfig`
- `apps/git/files/.config/git/gitignore_global` → `~/.config/git/gitignore_global`
- `apps/nvim/files/.config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `apps/tmux/files/.tmux.conf` → `~/.tmux.conf`
- `apps/zsh/files/.config/zsh/conf.d/20-shell-core.zsh` → `~/.config/zsh/conf.d/20-shell-core.zsh`

Bootstrap links these files using the shared helper in `bootstrap/lib.sh`.

## Bootstrap Tasks

The existing task runner is still the execution path when you run `./bootstrap/install.sh` with no flags.
It currently handles package installation plus machine-local setup such as:

- Git local config bootstrap
- Tmux plugin installation
- Zsh + starship setup
- Neovim installation
- NVM / Python / .NET tooling

## Important Paths

- Git config: `apps/git/files/.gitconfig`
- Zsh entry point: `apps/zsh/files/.zshrc`
- Zsh modules: `apps/zsh/files/.config/zsh/conf.d/`
- Tmux entry point: `apps/tmux/files/.tmux.conf`
- Tmux modules: `apps/tmux/files/.config/tmux/`
- Neovim config: `apps/nvim/files/.config/nvim/`
- Ghostty config: `apps/ghostty/files/.config/ghostty/config`

## Docs

- Architecture draft: `docs/ARCHITECTURE.md`
- Adding apps: `docs/ADDING_APPS.md`
- Apps overview: `apps/README.md`
