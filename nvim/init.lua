-- ============================================
-- Neovim Configuration
-- ============================================

-- ===== OPTIONS =====
vim.opt.number = true                -- Line numbers
vim.opt.relativenumber = true        -- Relative line numbers
vim.opt.mouse = 'a'                  -- Mouse support
vim.opt.clipboard = 'unnamedplus'    -- System clipboard
vim.opt.termguicolors = true         -- 24-bit colors
vim.opt.cursorline = true            -- Highlight current line
vim.opt.signcolumn = 'yes'           -- Always show sign column
vim.opt.scrolloff = 8                -- Lines above/below cursor
vim.opt.tabstop = 2                  -- Tab width
vim.opt.shiftwidth = 2               -- Indent width
vim.opt.expandtab = true             -- Spaces instead of tabs
vim.opt.smartindent = true           -- Smart indentation
vim.opt.ignorecase = true            -- Case insensitive search
vim.opt.smartcase = true             -- Case sensitive if uppercase
vim.opt.updatetime = 250             -- Faster updates
vim.opt.wrap = true                  -- Wrap lines

-- ===== LEADER KEY =====
vim.g.mapleader = ' '

-- ===== KEYMAPS =====
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Clear search' })

-- ===== BOOTSTRAP LAZY.NVIM =====
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===== HELPER: Find fd executable =====
local function find_fd()
  local paths = {
    '/opt/homebrew/bin/fd',  -- macOS ARM
    '/usr/local/bin/fd',     -- macOS Intel / Linux
    '/usr/bin/fd',           -- Linux
    'fd',                    -- Fallback to PATH
  }
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return 'fd'
end

local fd_cmd = find_fd()

-- ===== PLUGINS =====
require('lazy').setup({
  -- Theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({ flavour = 'mocha' })
      vim.cmd.colorscheme('catppuccin')
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
      if not status_ok then
        return
      end

      configs.setup({
        ensure_installed = {
          'markdown', 'markdown_inline',
          'lua', 'bash', 'python',
          'javascript', 'typescript', 'tsx',
          'json', 'yaml', 'html', 'css',
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    config = function()
      require('render-markdown').setup({})
    end,
  },

  -- Markdown preview in browser
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_relative_path = 1  -- Resolve images relative to markdown file
    end,
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview' },
    },
  },

  -- Image paste from clipboard
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        dir_path = 'assets',  -- Save images to ./assets folder
      },
    },
    keys = {
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from clipboard' },
    },
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = { theme = 'catppuccin' },
      })
    end,
  },

  -- LSP installer
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  -- Mason LSP config
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'ts_ls', 'bashls' },
      })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',  -- Use master for better nvim 0.11+ compatibility
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- Compatibility shim for treesitter ft_to_lang (nvim 0.11+)
      if vim.treesitter.language and not vim.treesitter.language.get_lang then
        vim.treesitter.language.get_lang = function(ft)
          -- Use filetype.get_option for nvim 0.11+
          local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
          if ok then return lang end
          -- Fallback to filetype
          return ft
        end
      end

      local telescope = require('telescope')

      telescope.setup({
        defaults = {
          layout_config = {
            width = 0.8,
            height = 0.8,
          },
        },
        pickers = {
          find_files = {
            find_command = { fd_cmd, '--type', 'f', '--hidden', '--exclude', '.git' },
          },
        },
      })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fa', function()
        builtin.find_files({
          cwd = vim.fn.expand('~'),
          find_command = { fd_cmd, '--type', 'f', '--max-depth', '4', '--exclude', '.git', '--exclude', 'Library', '--exclude', 'node_modules' },
        })
      end, { desc = 'Find all files (home)' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search text' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
    end,
  },
})

-- ===== LSP SETUP (new API for nvim 0.11+) =====
vim.lsp.config('pyright', {})
vim.lsp.config('ts_ls', {})
vim.lsp.config('bashls', {})
vim.lsp.enable({ 'pyright', 'ts_ls', 'bashls' })

-- ===== LSP KEYMAPS =====
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})
