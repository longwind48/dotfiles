return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	main = "nvim-treesitter",
	opts = {
		ensure_installed = {
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
		},
		sync_install = false,
		auto_install = true,
	},
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		-- Setup autotag
		require("nvim-ts-autotag").setup()

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
	end,
}
