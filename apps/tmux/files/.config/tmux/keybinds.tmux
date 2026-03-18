# Reload config with r
unbind r
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Improve copy mode with Vi bindings
setw -g mode-keys vi
