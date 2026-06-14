return {
  -- Inline image rendering for molten output (plots, etc.)
  -- Ghostty supports the kitty graphics protocol; tmux passthrough must be on.
  {
    "3rd/image.nvim",
    build = false, -- avoid luarocks; we provide deps via the kitty backend
    opts = {
      backend = "kitty",
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- Interactive code execution with a Jupyter kernel
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- pin to v1 to avoid breaking config changes
    dependencies = { "3rd/image.nvim" },
    -- load the plugin onto the rtp before updating the remote-plugin manifest,
    -- otherwise the keys-based lazy-load leaves molten off the rtp and the
    -- manifest is generated without it (=> "Not an editor command: MoltenInit").
    build = ":Lazy load molten-nvim | UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false -- avoid jank; show output on demand
      vim.g.molten_virt_text_output = true -- show output as virtual text under the cell
      vim.g.molten_virt_lines_off_by_1 = false
      vim.g.molten_wrap_output = true
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten: init kernel" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten: evaluate operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten: evaluate line" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten: re-evaluate cell" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Molten: evaluate visual" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Molten: show output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Molten: hide output" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Molten: delete cell" },
      { "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "Molten: interrupt kernel" },
      { "<leader>mn", "<cmd>MoltenNext<cr>", desc = "Molten: next cell" },
      { "<leader>mP", "<cmd>MoltenPrev<cr>", desc = "Molten: prev cell" }, -- mP: mp is markdown-preview
      { "<leader>mc", function() require("traci.molten_cell").run() end, ft = "markdown", desc = "Molten: run current ```python cell" },
      { "<leader>ma", function() require("traci.molten_cell").run_all() end, ft = "markdown", desc = "Molten: run all ```python cells" },
      { "<leader>ms", function() require("traci.molten_cell").export() end, ft = "markdown", desc = "Molten: export outputs to .ipynb" },
    },
  },

  -- Open .ipynb files as editable plaintext (markdown) and convert back on save.
  -- Without this, opening an .ipynb just shows the raw JSON. Uses the `jupytext`
  -- CLI from the neovim venv (PATH set in core/options.lua).
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- must register the .ipynb BufReadCmd before one is opened
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
    config = function(_, opts)
      require("jupytext").setup(opts)
      -- auto-export molten outputs on :w, auto-import on kernel init (.ipynb)
      require("traci.molten_cell").setup_persistence()
    end,
  },
}
