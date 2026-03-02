# ----------------------------
# Environment / PATH
# ----------------------------

export LANG="en_US.UTF-8"
export COLORTERM=truecolor
export DISABLE_AUTO_TITLE="true"

# Neovim in /opt (preferred over apt)
[[ -d "/opt/nvim/bin" ]] && export PATH="/opt/nvim/bin:$PATH"

# Local bins
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# .NET
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$HOME/.dotnet:$PATH"

# Editors
export EDITOR="nvim"
export VISUAL="nvim"
