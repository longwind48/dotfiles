# Neovim Cheatsheet

**Leader key: `Space`**

## Save & Quit

| Key | Action |
|-----|--------|
| `Space w` | Save file |
| `Space q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `Space ff` | Find files (current dir) |
| `Space fa` | Find files (from home ~) |
| `Space fg` | Search text in files |
| `Space fb` | List open buffers |
| `Space fr` | Recent files |
| `Space fh` | Search help |

**Search specific folder:** `:Telescope find_files cwd=~/path`

**Inside Telescope:**
| Key | Action |
|-----|--------|
| `Enter` | Open file |
| `Ctrl+n/p` | Next/prev result |
| `Esc` | Close |

## File Explorer (netrw)

| Key | Action |
|-----|--------|
| `:Ex` | Open explorer |
| `Enter` | Open file/folder |
| `-` | Go up directory |
| `%` | Create new file |
| `d` | Create directory |
| `D` | Delete file |
| `R` | Rename file |

## LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover docs |
| `gr` | Find references |
| `Space rn` | Rename symbol |
| `Space ca` | Code actions |

## Search

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `n` / `N` | Next / prev match |
| `*` | Search word under cursor |
| `Esc` | Clear highlight |
| `:%s/old/new/g` | Replace all |

## Plugins

| Command | Action |
|---------|--------|
| `:Lazy` | Plugin manager |
| `:Mason` | LSP installer |
| `:checkhealth` | Check health |
