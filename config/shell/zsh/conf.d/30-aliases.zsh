# ----------------------------
# Aliases
# ----------------------------

alias clr="clear"
alias cls="clear && ls"

# tmux
alias tl="tmux ls"
alias ta="tmux attach -t"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"
alias tx="tmuxinator start"

# eza (preferred) / exa (fallback)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -la'
  alias lt='eza -lT'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons --group-directories-first'
  alias ll='exa -la'
  alias lt='exa -lT'
fi

command -v lazygit >/dev/null 2>&1 && alias lzg='lazygit'

# bat
command -v bat >/dev/null 2>&1 && alias cat='bat --style=plain --paging=never'
