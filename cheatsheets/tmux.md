# Tmux Cheatsheet

**Prefix: `C-Space`** (Ctrl+Space)

## Sessions

| Command/Keybind | Action |
|-----------------|--------|
| `tn name` | New named session |
| `tl` | List sessions |
| `ta name` | Attach to session |
| `tk name` | Kill session |
| `tmux rename -t old new` | Rename session (CLI) |
| `C-Space d` | Detach |
| `C-Space s` | Session picker |
| `C-Space $` | Rename session |
| `C-Space (` | Previous session |
| `C-Space )` | Next session |

## Windows

| Keybind | Action |
|---------|--------|
| `C-Space c` | New window |
| `C-Space ,` | Rename window |
| `C-Space &` | Kill window |
| `C-Space n` | Next window |
| `C-Space p` | Previous window |
| `C-Space 0-9` | Go to window # |
| `C-Space w` | Window picker |
| `C-Space Space` | Last window |
| `Alt+Shift+H` | Previous window |
| `Alt+Shift+L` | Next window |

## Panes

| Keybind | Action |
|---------|--------|
| `C-Space \|` | Split vertical |
| `C-Space -` | Split horizontal |
| `C-Space x` | Kill pane |
| `C-Space z` | Toggle zoom |
| `C-Space !` | Pane → window |
| `C-Space q` | Show pane numbers |
| `C-Space {` | Move pane left |
| `C-Space }` | Move pane right |
| `C-Space o` | Cycle panes |
| `C-Space ;` | Last active pane |

## Pane Navigation (Vim-style)

| Keybind | Action |
|---------|--------|
| `C-Space h` | Go left |
| `C-Space j` | Go down |
| `C-Space k` | Go up |
| `C-Space l` | Go right |
| `C-h/j/k/l` | Navigate (vim-tmux-navigator) |

## Pane Resizing

| Keybind | Action |
|---------|--------|
| `C-Space H` | Resize left |
| `C-Space J` | Resize down |
| `C-Space K` | Resize up |
| `C-Space L` | Resize right |

## Copy Mode (Vi)

| Keybind | Action |
|---------|--------|
| `C-Space [` | Enter copy mode |
| `q` | Exit copy mode |
| `v` | Start selection |
| `C-v` | Rectangle select |
| `y` | Yank (copy) |
| `C-Space ]` | Paste |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next match |
| `N` | Previous match |

## Session Persistence (resurrect)

| Keybind | Action |
|---------|--------|
| `C-Space C-s` | Save session |
| `C-Space C-r` | Restore session |

## Plugins (TPM)

| Keybind | Action |
|---------|--------|
| `C-Space I` | Install plugins |
| `C-Space U` | Update plugins |
| `C-Space Alt+u` | Uninstall plugins |

## Config

| Keybind | Action |
|---------|--------|
| `C-Space r` | Reload config |
| `C-Space :` | Command prompt |

## Shell Aliases

| Alias | Command |
|-------|---------|
| `tl` | List sessions |
| `ta` | Attach last session |
| `ta name` | Attach to session |
| `tn name` | New named session |
| `tk name` | Kill session |
| `td` | Detach |
