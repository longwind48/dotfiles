# Keybindings Reference

Complete reference for tmux and Neovim keybindings.

## Tmux

**Prefix**: `Ctrl+Space` (instead of default `Ctrl+b`)

### Window & Pane Management

| Key | Action |
|-----|--------|
| `prefix + \|` | Split horizontally |
| `prefix + -` | Split vertically |
| `prefix + h/j/k/l` | Navigate panes |
| `prefix + H/J/K/L` | Resize panes |
| `Alt+Shift+H/L` | Previous/next window |
| `prefix + Space` | Toggle last window |

### Sessions

| Key | Action |
|-----|--------|
| `Alt+s` | Session picker |

### Other

| Key | Action |
|-----|--------|
| `prefix + r` | Reload config |

### Plugins

- tmux-sensible
- tmux-resurrect (session persistence)
  - `prefix + Ctrl+s` - Manual save
  - `prefix + Ctrl+r` - Manual restore
- tmux-continuum (auto-save)
- tmux-yank (system clipboard)
- vim-tmux-navigator
- catppuccin/tmux

## Neovim

**Leader**: `Space`

### File Operations

| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>q` | Quit |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |

### Markdown

| Key | Action |
|-----|--------|
| `<leader>mp` | Markdown preview |
| `<leader>p` | Paste image |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |

### Plugins

- catppuccin (theme)
- nvim-treesitter (syntax highlighting)
- telescope.nvim (fuzzy finder)
- lualine.nvim (status line)
- mason.nvim + mason-lspconfig (LSP management)
- render-markdown.nvim
- markdown-preview.nvim
- img-clip.nvim (paste images)

## Zsh Aliases

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

## Quick Reference in Terminal

Use the built-in cheatsheet commands for quick reference:

```bash
tmuxhelp  # View tmux keybindings with glow
nvimhelp  # View neovim keybindings with glow
```
