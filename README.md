# Dotfiles

Personal development environment for macOS and Linux with Ghostty, tmux, Neovim, and Zsh configurations.

## Quick Start

```bash
git clone https://github.com/longwind48/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's Included

- **Ghostty** terminal with Catppuccin Mocha theme, JetBrains Mono Nerd Font, and tmux-friendly settings
- **Tmux** with Catppuccin theme, vi-style navigation, session persistence, ccmux AI-agent picker/sidebar, and auto-naming of windows from your first Claude Code prompt
- **Neovim** with LSP support, fuzzy finding, markdown editing, and molten-nvim (Jupyter cells)
- **Zsh aliases** for tmux/nvim workflow shortcuts
- **Cheatsheets** accessible via `tmuxhelp` and `nvimhelp` commands

## Requirements

- macOS 12+ or Linux
- Nerd Font (automatically installed on macOS via install script)

Run `./install.sh deps` to check and install all dependencies.

## Post-Install

1. **Restart your terminal**

2. **Configure terminal font** (if you see weird symbols �):
   - Open terminal preferences
   - Set font to "JetBrainsMono Nerd Font Mono"
   - Restart terminal

3. **Start tmux**: Press `Ctrl+Space + I` to install plugins

4. **Initialize ccmux hooks** (if agent CLIs were installed after dotfiles):
   ```bash
   ccmux setup
   ```

5. **Open nvim**: Plugins install automatically on first launch

6. **Enable Zsh aliases**: Add to `~/.zshrc`:
   ```bash
   source ~/.config/zsh/aliases.zsh
   ```
   Then: `exec zsh`

7. **Wire the Claude Code window-rename hook** (optional, requires Claude Code):
   The install symlinks `~/.claude/bin/cc-tmux-rename.sh`, but it only runs once
   registered as a hook. `~/.claude/settings.json` isn't managed by this repo (it
   holds personal/credential config), so add this to its `hooks` object:
   ```json
   "UserPromptSubmit": [
     { "matcher": "", "hooks": [ { "type": "command", "command": "~/.claude/bin/cc-tmux-rename.sh" } ] }
   ]
   ```
   The tmux window then names itself from your first prompt each session (instant
   slug, upgraded to a tidy title by a background `claude -p` call), then locks.

## Key Features

### Tmux
- Prefix: `Ctrl+Space`
- Vi-style navigation and copy mode
- Session persistence with tmux-resurrect
- Quick session picker: `Alt+s`
- ccmux AI-agent picker: `Alt+p`
- ccmux sidebar toggle: `Alt+Shift+p`

### Neovim
- Leader: `Space`
- Fuzzy finding: `<leader>ff` (files), `<leader>fg` (grep)
- LSP support with Mason (Python, TypeScript, Bash)
- Markdown preview: `<leader>mp`

### Zsh
- `ta <name>` - Attach to tmux session
- `tn <name>` - New tmux session
- `vi` / `vim` - Open Neovim

## Documentation

- [Keybindings Reference](docs/KEYBINDINGS.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- In terminal: `tmuxhelp` or `nvimhelp`

## Installation Options

```bash
./install.sh           # Install everything
./install.sh ghostty   # Install Ghostty only
./install.sh tmux      # Install tmux only
./install.sh nvim      # Install neovim (config + Python venv)
./install.sh nvim-venv # Create/update neovim Python venv only
./install.sh zsh       # Install zsh aliases only
./install.sh deps      # Check/install dependencies
./install.sh uninstall # Remove all symlinks
```

## License

MIT
