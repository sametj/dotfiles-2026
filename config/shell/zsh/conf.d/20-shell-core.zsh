# ------------------------------
# Shell core setup (without Oh My Zsh)
# ------------------------------

autoload -Uz compinit
compinit

# Basic completion style
zstyle ':completion:*' menu select

# ------------------------------
# Starship prompt
# ------------------------------

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
