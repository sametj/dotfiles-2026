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
    
- Symlink configs
    
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

dotfiles/  
│  
├── bin/                # Custom CLI tools (added to PATH)  
│  
├── bootstrap/          # Installer logic  
│   ├── install.sh      # Entry point  
│   ├── lib.sh          # Shared helpers  
│   └── tasks/          # Modular install steps  
│  
├── config/  
│   ├── git/            # Git config  
│   ├── nvim/           # Neovim config (Lazy.nvim)  
│   ├── shell/          # Zsh config (modular)  
│   └── tmux/           # Tmux config (manual Catppuccin)  
│  
└── README.md

---

# 🖥 Zsh Setup

- Zsh shell
    
- Starship prompt
    
- Modular config via `conf.d/`
    
- Tools:
    
    - zoxide
        
    - fzf
        
    - bat
        
    - eza
        
    - ripgrep
        
    - fd
        

Zsh entry file:

config/shell/zsh/zshrc

Prompt is initialized from `config/shell/zsh/conf.d/20-shell-core.zsh` (Starship).

---

# 🧩 Tmux Setup

Manual Catppuccin install (TPM is also installed for plugin management).

Plugin path:

~/.config/tmux/plugins/catppuccin/tmux

Bootstrap ensures it’s cloned and pinned.

Entry config:

config/tmux/tmux.conf

Modular files:

- core.conf
    
- keybinds.tmux
    
- theme.conf
    
- status.conf
    
- plugins.conf
    

---

# 🧠 Neovim Setup

- Lazy.nvim
    
- LSP
    
- Treesitter
    
- Modular plugin structure
    
- Yazi integration
    
- Theming support (Catppuccin, Kanagawa, Github)
    

Config path:

config/nvim/

---

# 🔧 Bootstrap Tasks

Located in:

bootstrap/tasks/

Each file is independent and executable. Current tasks include:

- `00_locale.sh`
- `01_packages.sh`
- `02_git.sh`
- `03_ssh.sh`
- `05_yazi.sh`
- `10_tmux.sh`
- `15_zsh.sh`
- `20_nvim.sh`
- `25_nvm.sh`
- `30_python_cli.sh`
- `35_dotnet.sh`
- `40_netcoredbg.sh`

They are executed in lexical order by `install.sh`.

---

# 🔄 Updating

To update the environment:

cd ~/dotfiles  
git pull  
./bootstrap/install.sh

---

# 📌 Requirements

- Ubuntu 22.04+ or WSL
    
- sudo access
    
- Git
    

---

## ⚠️ Troubleshooting (Stow conflict with `.zshrc`)

If you see an error like:

`cannot stow .../.zshrc over existing target .zshrc since neither a link nor a directory`

it means `~/.zshrc` is currently a regular file. This repo's bootstrap handles that automatically by backing up the file and creating a symlink.

Recommended fix:

```bash
./bootstrap/install.sh
```

If you still want to use GNU Stow directly, move the existing file first, then stow:

```bash
mv ~/.zshrc ~/.zshrc.pre-dotfiles
# then run your stow command
```

---

# 🛠 Useful Commands

Restart tmux cleanly:

tmux kill-server  
tmux

Check Neovim version:

nvim --version

---

# 🎯 Future Improvements
- Headless tmux plugin sync
- Neovim auto-update task
- LazyGit bootstrap task
- Better idempotency checks
- CI validation script

---

## ⚙️ Notes

This setup is designed to be:
- Portable
- Minimal
- Deterministic
- Fast
    
Re-run bootstrap anytime to reapply configuration.
