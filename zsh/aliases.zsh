# ============================================
# Shell Aliases
# ============================================
# Source this file in your .zshrc:
#   source ~/Projects/dotfiles/zsh/aliases.zsh
# Or symlink via install.sh

# Tmux aliases
alias ta='tmux a -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'
alias td='tmux detach'
[[ -x "$HOME/.local/bin/ccmux" ]] && alias ccmux="$HOME/.local/bin/ccmux"

# Neovim
alias vi='nvim'
alias vim='nvim'

# Cheatsheets (requires glow: brew install glow)
# These paths are set by install.sh to use symlinked locations
alias tmuxhelp='glow -p ~/.config/cheatsheets/tmux.md'
alias nvimhelp='glow -p ~/.config/cheatsheets/nvim.md'
