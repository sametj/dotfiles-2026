# ------------------------------
# Oh My Zsh
# ------------------------------

export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Disable OMZ update prompts (bootstrap handles updates)
zstyle ':omz:update' mode disabled


# ------------------------------
# Plugins (keep minimal)
# ------------------------------

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-interactive-cd
)


# ------------------------------
# Load Oh My Zsh
# ------------------------------

if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi


# ------------------------------
# Load Powerlevel10k config
# ------------------------------

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
