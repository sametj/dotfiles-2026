# ----------------------------
# Oh My Zsh
# ----------------------------

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Auto-update behavior
zstyle ':omz:update' mode auto

# Plugins (keep it lean)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-interactive-cd
)

# Load OMZ if installed
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi
