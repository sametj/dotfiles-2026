# Load modular zsh configuration from ~/.config/zsh/conf.d
for file in "$HOME/.config/zsh/conf.d"/*.zsh(N); do
  source "$file"
done

# User bin first
export PATH="$HOME/.local/bin:$PATH"
