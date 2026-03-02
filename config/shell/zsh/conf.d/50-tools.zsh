# ----------------------------
# Tool integration / fixes
# ----------------------------

# Ubuntu naming fixes
command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'
command -v batcat  >/dev/null 2>&1 && alias bat='batcat'

# fzf keybindings + completion (Ubuntu package)
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh

# zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
