return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Install parsers
    local ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "python",
      "c",
    }

    -- Auto-install missing parsers
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local ft = vim.bo.filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if vim.tbl_contains(ensure_installed, lang) then
          pcall(function()
            if not pcall(vim.treesitter.language.inspect, lang) then
              vim.cmd("TSInstall " .. lang)
            end
          end)
        end
      end,
    })

    -- Enable treesitter highlighting and indentation
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Incremental selection keymaps
    vim.keymap.set("n", "<C-space>", function()
      require("nvim-treesitter.incremental_selection").init_selection()
    end, { desc = "Init treesitter selection" })

    vim.keymap.set("x", "<C-space>", function()
      require("nvim-treesitter.incremental_selection").node_incremental()
    end, { desc = "Increment treesitter selection" })

    vim.keymap.set("x", "<bs>", function()
      require("nvim-treesitter.incremental_selection").node_decremental()
    end, { desc = "Decrement treesitter selection" })

    -- Setup autotag
    require("nvim-ts-autotag").setup()
  end,
}
