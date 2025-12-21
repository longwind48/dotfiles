# Troubleshooting

Common issues and their solutions.

## Weird symbols (�) in tmux status bar

**Cause**: Terminal not using a Nerd Font

**Fix**:
1. Install Nerd Font: `./install.sh fonts`
2. Configure terminal to use "JetBrainsMono Nerd Font Mono"
3. Restart terminal completely
4. Restart tmux: `tmux kill-server && tmux`

## "tmux-resurrect files not found" error

**Cause**: Fresh install trying to restore non-existent sessions

**Fix**: Already handled by install script (creates `~/.tmux/resurrect/` directory)

If error persists:
```bash
mkdir -p ~/.tmux/resurrect
tmux kill-server
tmux
```

## nvim-treesitter "module not found" error

**Cause**: Treesitter plugin not fully installed or corrupted

**Fix**:
```bash
# Remove treesitter and reinstall
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
nvim --headless "+Lazy! sync" +qa
```

Note: The config already includes error handling (`pcall`) to gracefully fail if treesitter isn't available.

## Neovim plugins not loading

**Fix**:
```bash
# Remove plugin cache and reinstall
rm -rf ~/.local/share/nvim/lazy
nvim --headless "+Lazy! sync" +qa
```

## Telescope "ft_to_lang" error

**Cause**: Version incompatibility between Telescope and Treesitter

**Symptoms**:
```
Error executing vim.schedule lua callback: ...telescope/previewers/utils.lua:135:
attempt to call field 'ft_to_lang' (a nil value)
```

**Fix**: Already resolved in the config. If you encounter this:
```bash
# Remove telescope and reinstall
rm -rf ~/.local/share/nvim/lazy/telescope.nvim
nvim --headless "+Lazy! sync" +qa
```

The config now uses `branch = '0.1.x'` instead of a specific tag for better compatibility.

## LSP servers not working

**Fix**:
```bash
# Open nvim and run
:MasonInstall pyright typescript-language-server bash-language-server
```

## Aliases not working

**Cause**: Aliases not sourced in shell

**Fix**: Add to `~/.zshrc`:
```bash
source ~/.config/zsh/aliases.zsh
```
Then reload: `exec zsh`
