# ============================================
# Dotfiles Makefile
# ============================================

.PHONY: all install tmux nvim zsh cheatsheets deps fonts uninstall help

all: install

install: ## Install all configurations
	@./install.sh install

tmux: ## Install only tmux configuration
	@./install.sh tmux

nvim: ## Install only neovim configuration
	@./install.sh nvim

zsh: ## Install only zsh aliases
	@./install.sh zsh

cheatsheets: ## Install only cheatsheets
	@./install.sh cheatsheets

deps: ## Check/install dependencies and fonts
	@./install.sh deps

fonts: ## Check/install Nerd Font
	@./install.sh fonts

uninstall: ## Remove symlinks
	@./install.sh uninstall

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
