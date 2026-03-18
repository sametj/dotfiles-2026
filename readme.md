# 📦 TJ Dotfiles

Personal development environment setup for Linux (Ubuntu / WSL).

This repository manages:

- Zsh + Starship (modular config)
- Tmux (manual Catppuccin theme)
- Neovim (Lazy.nvim-based setup)
- Modern CLI tools (ripgrep, fd, fzf, eza, etc.)
- Git configuration
- Bootstrap installer for full system setup

---

## 🚀 Quick Start

Clone the repo:

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run bootstrap:

```shell
./bootstrap/install.sh
```

This will:

- Install required packages
- Symlink dotfiles to your home directory
- Install tmux + Catppuccin theme
- Install Zsh + Starship prompt
- Install Neovim
- Install modern CLI tools

---

# 🧠 Philosophy

- Repo contains **your configuration only**
- Third-party plugins are installed via bootstrap
- No system pollution
- Everything reproducible
- Safe to re-run (idempotent design)

---

# 📁 Structure

```
dotfiles/
├── bootstrap/          # Installer logic
│   ├── install.sh      # Entry point
│   ├── lib.sh          # Shared helpers
│   └── tasks/          # Modular install steps
└── config/             # Source config files
    ├── git/            # Git config
    ├── ghostty/        # Ghostty terminal config
    ├── nvim/           # Neovim config (Lazy.nvim)
    ├── shell/          # Zsh config (modular)
    └── tmux/           # Tmux config (manual Catppuccin)
```

---

# 🖥 Zsh Setup

- Zsh shell
- Starship prompt
- Modular config via `conf.d/`
- Tools: zoxide, fzf, bat, eza, ripgrep, fd

Zsh entry file: `config/shell/zsh/zshrc`

Prompt is initialized from `config/shell/zsh/conf.d/20-shell-core.zsh` (Starship).

---

# 🧩 Tmux Setup

Manual Catppuccin install (TPM is also installed for plugin management).

Plugin path: `~/.local/share/tmux/plugins/catppuccin/tmux`

Bootstrap ensures it's cloned and pinned. `~/.tmux.conf` is symlinked by bootstrap.

Entry config: `config/tmux/tmux.conf`

Modular files: `core.conf`, `keybinds.tmux`, `theme.conf`, `status.conf`, `plugins.conf`

---

# 🧠 Neovim Setup

- Lazy.nvim
- LSP
- Treesitter
- Modular plugin structure
- Yazi integration
- Theming support (Catppuccin, Kanagawa, Github)

Config path: `config/nvim/` (`~/.config/nvim` is symlinked by bootstrap.)

---

# 🔧 Bootstrap Tasks

Located in `bootstrap/tasks/`. Each file is independent and executable:

- `02_git.sh`
- `10_tmux.sh`
- `12_ghostty.sh`
- `15_zsh.sh`
- `20_nvim.sh`

They are executed in order by `install.sh`.

---

# 🔄 Updating

```bash
cd ~/dotfiles
git pull
./bootstrap/install.sh
```

---

# 📌 Requirements

- Ubuntu 22.04+ or WSL
- sudo access
- Git

---

## ⚠️ Troubleshooting (conflict with `.zshrc`)

If bootstrap reports backing up `~/.zshrc`, it means a regular file exists there.
Bootstrap automatically backs it up with a `.bak.<timestamp>` suffix and creates the symlink.

---

# 🛠 Useful Commands

Restart tmux cleanly:

```bash
tmux kill-server
tmux
```

Check Neovim version:

```bash
nvim --version
```

---

# 🎯 Future Improvements
- Headless tmux plugin sync
- Neovim auto-update task
- LazyGit bootstrap task
- Better idempotency checks
- ShellCheck in CI

---

## ⚙️ Notes

This setup is designed to be portable, minimal, deterministic, and fast.

Re-run bootstrap anytime to reapply configuration.
