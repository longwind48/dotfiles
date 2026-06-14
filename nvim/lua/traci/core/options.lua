vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- python host for remote plugins (molten-nvim) -- dedicated uv venv
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python")
-- let cairosvg find homebrew's libcairo (SVG transparency in molten output)
vim.env.DYLD_FALLBACK_LIBRARY_PATH = "/opt/homebrew/lib"
-- put the neovim venv bin on PATH so jupytext.nvim finds the `jupytext` CLI
vim.env.PATH = vim.fn.expand("~/.virtualenvs/neovim/bin") .. ":" .. vim.env.PATH
