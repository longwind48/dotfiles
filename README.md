# Dotfiles

Personal configurations for tmux and Neovim, designed for sharing across macOS and Linux workstations.

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

Or using Make:

```bash
make install
```

## What's Included

### Tmux

- **Prefix**: `Ctrl+Space` (instead of `Ctrl+b`)
- **Vi-style** copy mode and pane navigation
- **Mouse support** enabled
- **24-bit color** support
- **Catppuccin Mocha** theme

#### Key Bindings

| Key | Action |
|-----|--------|
| `prefix + \|` | Split horizontally |
| `prefix + -` | Split vertically |
| `prefix + h/j/k/l` | Navigate panes |
| `prefix + H/J/K/L` | Resize panes |
| `Alt+Shift+H/L` | Previous/next window |
| `prefix + Space` | Toggle last window |
| `Alt+s` | Session picker |
| `prefix + r` | Reload config |

#### Plugins (via TPM)

- tmux-sensible
- tmux-resurrect (session persistence)
- tmux-continuum (auto-save)
- tmux-yank (system clipboard)
- vim-tmux-navigator
- catppuccin/tmux

### Neovim

- **Leader**: `Space`
- **Plugin manager**: lazy.nvim (auto-bootstraps)
- **Theme**: Catppuccin Mocha
- **LSP**: pyright, ts_ls, bashls (via Mason)

#### Key Bindings

| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>mp` | Markdown preview |
| `<leader>p` | Paste image |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |

#### Plugins

- catppuccin (theme)
- nvim-treesitter (syntax highlighting)
- telescope.nvim (fuzzy finder)
- lualine.nvim (status line)
- mason.nvim + mason-lspconfig (LSP management)
- render-markdown.nvim
- markdown-preview.nvim
- img-clip.nvim (paste images)

### Zsh Aliases

| Alias | Command |
|-------|---------|
| `ta <name>` | Attach to tmux session |
| `tn <name>` | New tmux session |
| `tl` | List tmux sessions |
| `tk <name>` | Kill tmux session |
| `td` | Detach from tmux |
| `vi` / `vim` | Open neovim |
| `tmuxhelp` | Show tmux cheatsheet |
| `nvimhelp` | Show neovim cheatsheet |

### Cheatsheets

Quick reference guides viewable in terminal using `glow`:

- `tmuxhelp` - Tmux keybindings and commands
- `nvimhelp` - Neovim keybindings and commands

## Dependencies

| Tool | Purpose | Install |
|------|---------|---------|
| git | Version control | Required |
| neovim | Editor (0.11+) | `brew install neovim` |
| tmux | Terminal multiplexer | `brew install tmux` |
| fd | File finder | `brew install fd` |
| ripgrep | Text search | `brew install ripgrep` |
| node | For markdown-preview | `brew install node` |
| glow | Markdown viewer | `brew install glow` |

Check dependencies:

```bash
./install.sh deps
```

## Installation Options

```bash
# Install everything
./install.sh

# Install specific configs
./install.sh tmux
./install.sh nvim
./install.sh zsh
./install.sh cheatsheets

# Check dependencies
./install.sh deps

# Uninstall (removes symlinks)
./install.sh uninstall
```

## Post-Installation

1. **Zsh**: Add to `~/.zshrc`:
   ```bash
   source ~/.config/zsh/aliases.zsh
   ```

2. **Tmux**: Start tmux and press `prefix + I` to install plugins

3. **Neovim**: Open nvim - lazy.nvim will auto-install plugins

## Structure

```
dotfiles/
├── cheatsheets/
│   ├── tmux.md
│   └── nvim.md
├── nvim/
│   └── init.lua
├── tmux/
│   └── tmux.conf
├── zsh/
│   └── aliases.zsh
├── install.sh
├── Makefile
└── README.md
```

## Symlink Locations

| Source | Destination |
|--------|-------------|
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `nvim/init.lua` | `~/.config/nvim/init.lua` |
| `zsh/aliases.zsh` | `~/.config/zsh/aliases.zsh` |
| `cheatsheets/tmux.md` | `~/.config/cheatsheets/tmux.md` |
| `cheatsheets/nvim.md` | `~/.config/cheatsheets/nvim.md` |

## Backups

Existing configs are backed up to `~/.dotfiles_backup/TIMESTAMP/` before symlinking.

## License

MIT
