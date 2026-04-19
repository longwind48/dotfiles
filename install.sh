#!/usr/bin/env bash
# ============================================
# Dotfiles Installation Script
# ============================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)  echo "linux" ;;
        *)      echo "unknown" ;;
    esac
}

OS=$(detect_os)
info "Detected OS: $OS"

# Backup existing file/directory
backup() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        warn "Backed up existing $target to $BACKUP_DIR/"
    fi
}

# Create symlink
link() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        backup "$dst"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    success "Linked $dst -> $src"
}

# Install tmux configuration
install_tmux() {
    info "Installing tmux configuration..."
    link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Install TPM if not present
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM installed. Press prefix + I inside tmux to install plugins."
    else
        success "TPM already installed."
    fi

    # Create resurrect directory to prevent errors on fresh installs
    mkdir -p "$HOME/.tmux/resurrect"
    success "Tmux resurrect directory created."
}

# Install ghostty configuration
install_ghostty() {
    info "Installing Ghostty configuration..."
    # XDG location (works on Linux and macOS)
    link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

    # macOS also reads from Application Support — symlink the legacy filename too
    if [[ "$OS" == "macos" ]]; then
        link "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
    fi
    success "Ghostty config installed. Reload with Cmd+Shift+,"
}

# Install neovim configuration
install_nvim() {
    info "Installing Neovim configuration..."
    mkdir -p "$HOME/.config/nvim"
    link "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
    success "Neovim config installed. Plugins will install on first launch."
}

# Install cheatsheets
install_cheatsheets() {
    info "Installing cheatsheets..."
    mkdir -p "$HOME/.config/cheatsheets"
    link "$DOTFILES_DIR/cheatsheets/tmux.md" "$HOME/.config/cheatsheets/tmux.md"
    link "$DOTFILES_DIR/cheatsheets/nvim.md" "$HOME/.config/cheatsheets/nvim.md"
    success "Cheatsheets installed. Use 'tmuxhelp' and 'nvimhelp' commands."
}

# Install zsh aliases
install_zsh() {
    info "Installing zsh aliases..."
    mkdir -p "$HOME/.config/zsh"
    link "$DOTFILES_DIR/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"

    # Check if already sourced in .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "source.*aliases.zsh" "$HOME/.zshrc" 2>/dev/null; then
            echo
            warn "Add this line to your ~/.zshrc to enable aliases:"
            echo -e "  ${GREEN}source ~/.config/zsh/aliases.zsh${NC}"
            echo
        else
            success "Aliases already sourced in ~/.zshrc"
        fi
    fi
}

# Install Nerd Font
install_fonts() {
    info "Checking for Nerd Font..."

    if [[ "$OS" == "macos" ]]; then
        # Check if JetBrains Mono Nerd Font is installed
        if ls ~/Library/Fonts/*JetBrainsMono*Nerd* >/dev/null 2>&1; then
            success "Nerd Font already installed."
        else
            warn "Nerd Font not found. The Catppuccin tmux theme requires a Nerd Font."
            if command -v brew >/dev/null; then
                read -p "Install JetBrains Mono Nerd Font with Homebrew? [y/N] " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    brew install --cask font-jetbrains-mono-nerd-font
                    success "Nerd Font installed."
                    echo
                    warn "IMPORTANT: Configure your terminal to use 'JetBrainsMono Nerd Font Mono'"
                    warn "  iTerm2: Preferences → Profiles → Text → Font"
                    warn "  Terminal.app: Preferences → Profiles → Font"
                    warn "Without this, tmux will show weird symbols (�) instead of icons."
                    echo
                fi
            else
                warn "Homebrew not found. Install manually from: https://www.nerdfonts.com/"
            fi
        fi
    elif [[ "$OS" == "linux" ]]; then
        info "On Linux, install a Nerd Font manually:"
        info "  https://www.nerdfonts.com/font-downloads"
        info "  Recommended: JetBrains Mono Nerd Font"
    fi
}

# Install dependencies (optional)
install_deps() {
    info "Checking dependencies..."

    local missing=()

    # Check required tools
    command -v git >/dev/null || missing+=("git")
    command -v nvim >/dev/null || missing+=("neovim")
    command -v tmux >/dev/null || missing+=("tmux")
    command -v fd >/dev/null || missing+=("fd")
    command -v rg >/dev/null || missing+=("ripgrep")
    command -v node >/dev/null || missing+=("node")
    command -v glow >/dev/null || missing+=("glow")

    if [[ ${#missing[@]} -gt 0 ]]; then
        warn "Missing dependencies: ${missing[*]}"

        if [[ "$OS" == "macos" ]] && command -v brew >/dev/null; then
            read -p "Install missing dependencies with Homebrew? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                brew install "${missing[@]}"
            fi
        elif [[ "$OS" == "linux" ]]; then
            warn "Please install: ${missing[*]}"
            warn "  Ubuntu/Debian: sudo apt install neovim tmux fd-find ripgrep nodejs glow"
            warn "  Arch: sudo pacman -S neovim tmux fd ripgrep nodejs glow"
        fi
    else
        success "All dependencies installed."
    fi

    # Check and install Nerd Font
    install_fonts
}

# Uninstall (remove symlinks, restore backups)
uninstall() {
    info "Uninstalling dotfiles..."

    # Remove symlinks
    [[ -L "$HOME/.tmux.conf" ]] && rm "$HOME/.tmux.conf" && success "Removed ~/.tmux.conf"
    [[ -L "$HOME/.config/ghostty/config" ]] && rm "$HOME/.config/ghostty/config" && success "Removed ~/.config/ghostty/config"
    [[ -L "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ]] && rm "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" && success "Removed ghostty macOS config"
    [[ -L "$HOME/.config/nvim/init.lua" ]] && rm "$HOME/.config/nvim/init.lua" && success "Removed ~/.config/nvim/init.lua"
    [[ -L "$HOME/.config/cheatsheets/tmux.md" ]] && rm "$HOME/.config/cheatsheets/tmux.md" && success "Removed ~/.config/cheatsheets/tmux.md"
    [[ -L "$HOME/.config/cheatsheets/nvim.md" ]] && rm "$HOME/.config/cheatsheets/nvim.md" && success "Removed ~/.config/cheatsheets/nvim.md"
    [[ -L "$HOME/.config/zsh/aliases.zsh" ]] && rm "$HOME/.config/zsh/aliases.zsh" && success "Removed ~/.config/zsh/aliases.zsh"

    # Clean up empty directories
    rmdir "$HOME/.config/cheatsheets" 2>/dev/null || true
    rmdir "$HOME/.config/zsh" 2>/dev/null || true

    # Show backup location if exists
    if [[ -d "$HOME/.dotfiles_backup" ]]; then
        info "Backups available at: $HOME/.dotfiles_backup/"
    fi
}

# Show help
show_help() {
    cat << EOF
Dotfiles Installation Script

Usage: ./install.sh [command]

Commands:
    install     Install all configurations (default)
    tmux        Install only tmux configuration
    ghostty     Install only Ghostty configuration
    nvim        Install only neovim configuration
    zsh         Install only zsh aliases
    cheatsheets Install only cheatsheets
    deps        Check/install dependencies and Nerd Font
    fonts       Check/install Nerd Font only
    uninstall   Remove symlinks
    help        Show this help message

Examples:
    ./install.sh              # Install everything
    ./install.sh tmux         # Install only tmux
    ./install.sh deps         # Check dependencies
    ./install.sh fonts        # Install Nerd Font
EOF
}

# Main
main() {
    case "${1:-install}" in
        install)
            install_deps
            install_tmux
            install_ghostty
            install_nvim
            install_cheatsheets
            install_zsh
            echo
            success "Dotfiles installation complete!"
            info "Next steps:"
            info "  1. Add 'source ~/.config/zsh/aliases.zsh' to ~/.zshrc"
            info "  2. Start tmux and press prefix + I to install plugins"
            info "  3. Open nvim - plugins will install automatically"
            info "  4. Use 'tmuxhelp' and 'nvimhelp' for cheatsheets"
            ;;
        tmux)
            install_tmux
            ;;
        ghostty)
            install_ghostty
            ;;
        nvim)
            install_nvim
            ;;
        zsh)
            install_zsh
            ;;
        cheatsheets)
            install_cheatsheets
            ;;
        deps)
            install_deps
            ;;
        fonts)
            install_fonts
            ;;
        uninstall)
            uninstall
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
