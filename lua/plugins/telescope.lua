return {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
		},
		config = function()
			local telescope = require("telescope")

			-- first setup telescope
			telescope.setup({
				-- your config
			})

			-- then load the extension
			telescope.load_extension("live_grep_args")

			vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "Find files" })
			-- vim.keymap.set("n", "<leader>fg", telescope.builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, { desc = "Live grep args" })
		end,
	},
}
