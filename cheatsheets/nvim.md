# Neovim Cheatsheet

**Leader key: `Space`**

## General

| Key | Action |
|-----|--------|
| `Space w` | Save file |
| `Space q` | Quit |
| `jk` | Exit insert mode |
| `Space nh` | Clear search highlights |
| `Esc` | Clear search |

## Windows & Splits

| Key | Action |
|-----|--------|
| `Space sv` | Split vertical |
| `Space sh` | Split horizontal |
| `Space se` | Equal splits |
| `Space sx` | Close split |
| `Ctrl+h/j/k/l` | Navigate splits (tmux aware) |
| `Ctrl+w h/j/k/l` | Alternative: navigate splits |

## Tabs

| Key | Action |
|-----|--------|
| `Space to` | New tab |
| `Space tx` | Close tab |
| `Space tn` | Next tab |
| `Space tp` | Prev tab |
| `gt` / `gT` | Next / prev tab (vim builtin) |
| `{n}gt` | Go to tab n (e.g., `2gt`) |
| `:tabnew` | New tab (command) |

## Neo-tree (File Explorer)

| Key | Action |
|-----|--------|
| `Space ee` | Toggle file explorer |
| `Space ef` | Reveal current file |
| `Space eb` | Show buffers panel |
| `Space es` | Show document symbols |
| `Space eg` | Git status (float) |

**Inside Neo-tree:**
| Key | Action |
|-----|--------|
| `Enter` | Open file |
| `s` | Open in vertical split |
| `S` | Open in horizontal split |
| `t` | Open in new tab |
| `a` | Add file/folder |
| `d` | Delete |
| `r` | Rename |
| `Y` | Copy path to clipboard |
| `O` | Open with system app |
| `q` | Close |

**Toggle between explorer & editor:**
| Key | Action |
|-----|--------|
| `Space ee` | Toggle explorer open/close |
| `Ctrl+h` | Jump to explorer (from editor) |
| `Ctrl+l` | Jump to editor (from explorer) |

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `Space ff` | Find files |
| `Space fr` | Recent files |
| `Space fs` | Search text (grep) |
| `Space fc` | Search word under cursor |
| `Space ft` | Find TODOs |

**Inside Telescope:**
| Key | Action |
|-----|--------|
| `Enter` | Open file |
| `Ctrl+n/p` | Next/prev result |
| `Esc` | Close |

## Flash (Motion)

| Key | Action |
|-----|--------|
| `s` | Flash jump (type chars to jump) |
| `S` | Flash treesitter (select nodes) |
| `r` | Remote flash (operator mode) |
| `Ctrl+s` | Toggle flash in search |

## LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gR` | Show references (Telescope) |
| `gi` | Show implementations |
| `gt` | Show type definitions |
| `K` | Hover docs |
| `Space ca` | Code actions |
| `Space rn` | Rename symbol |
| `Space D` | Buffer diagnostics |
| `Space d` | Line diagnostics |
| `[d` / `]d` | Prev/next diagnostic |
| `Space rs` | Restart LSP |

## Debugging (nvim-dap)

| Key | Action |
|-----|--------|
| `Space db` | Toggle breakpoint |
| `Space dB` | Conditional breakpoint |
| `Space dc` | Continue/Start |
| `Space di` | Step into |
| `Space do` | Step over |
| `Space dO` | Step out |
| `Space dt` | Toggle DAP UI |
| `Space dr` | Toggle REPL |
| `Space dl` | Run last |
| `Space dx` | Terminate |

## Git

| Key | Action |
|-----|--------|
| `Space lg` | Open Lazygit |
| `]h` / `[h` | Next/prev hunk |
| `Space hs` | Stage hunk |
| `Space hr` | Reset hunk |
| `Space hS` | Stage buffer |
| `Space hR` | Reset buffer |
| `Space hu` | Undo stage hunk |
| `Space hp` | Preview hunk |
| `Space hb` | Blame line |
| `Space hB` | Toggle line blame |
| `Space hd` | Diff hunk |

## Diffview (Git Diffs)

| Key | Action |
|-----|--------|
| `Space gd` | Open diff view |
| `Space gD` | Close diff view |
| `Space gh` | File history (current) |
| `Space gH` | File history (repo) |

**Inside Diffview:**
| Key | Action |
|-----|--------|
| `Tab` | Toggle file panel |
| `q` | Close |

## Substitute

| Key | Action |
|-----|--------|
| `Space s` | Substitute with motion |
| `Space ss` | Substitute line |
| `Space S` | Substitute to EOL |

## Surround

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |

## Comments

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc{motion}` | Toggle comment |
| `gbc` | Toggle block comment |

## Trouble (Diagnostics)

| Key | Action |
|-----|--------|
| `Space xx` | Toggle Trouble |
| `Space xw` | Workspace diagnostics |
| `Space xd` | Document diagnostics |
| `Space xq` | Quickfix list |
| `Space xl` | Location list |

## TODO Comments

| Key | Action |
|-----|--------|
| `]t` / `[t` | Next/prev TODO |
| `Space ft` | Search TODOs (Telescope) |

## Formatting & Linting

| Key | Action |
|-----|--------|
| `Space mp` | Format file/range |
| `Space l` | Trigger linting |

## Session

| Key | Action |
|-----|--------|
| `Space wr` | Restore session |
| `Space ws` | Save session |

## Misc

| Key | Action |
|-----|--------|
| `Space +` / `Space -` | Increment/decrement number |
| `Space sm` | Maximize/minimize split |

## Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Plugin manager |
| `:Mason` | LSP/tool installer |
| `:checkhealth` | Check health |
| `:MarkdownPreview` | Preview markdown |
