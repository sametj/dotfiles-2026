# ------------------------------
# NVM (Node Version Manager)
# ------------------------------

export NVM_DIR="$HOME/.nvm"

# Load nvm if installed
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# Load nvm bash completion if available
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

# Ensure default Node is active
if command -v nvm >/dev/null 2>&1; then
  nvm use --silent default >/dev/null 2>&1 || true
fi
