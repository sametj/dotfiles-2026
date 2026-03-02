# Powerlevel10k instant prompt (must be near the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load p10k config if present
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
