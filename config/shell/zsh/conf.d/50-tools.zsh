# ------------------------------
# Tool integration / fixes
# ------------------------------

# ------------------------------
# Ubuntu naming fixes
# ------------------------------

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  alias fd='fdfind'
fi

if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  alias bat='batcat'
fi


# ------------------------------
# fzf keybindings + completion
# ------------------------------

# macOS (Homebrew)
if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$(brew --prefix fzf 2>/dev/null)"
  if [[ -n "$FZF_PREFIX" ]]; then
    [[ -f "$FZF_PREFIX/shell/key-bindings.zsh" ]] && source "$FZF_PREFIX/shell/key-bindings.zsh"
    [[ -f "$FZF_PREFIX/shell/completion.zsh" ]] && source "$FZF_PREFIX/shell/completion.zsh"
  fi
fi

# Ubuntu / Debian
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh


# ------------------------------
# zoxide
# ------------------------------

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
