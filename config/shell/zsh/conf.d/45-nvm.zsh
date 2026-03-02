# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Ensure "default" node is active in non-interactive shells too (scripts, tmux hooks, etc.)
if command -v nvm >/dev/null 2>&1; then
  nvm use --silent default >/dev/null 2>&1 || true
fi
