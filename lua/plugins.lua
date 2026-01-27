-- Add plugins here
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},


	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
	},

	{
		"numToStr/Comment.nvim",
		opts = {
			mappings = false,
			-- add any options here
		},
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_cout = true,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						".git",
					},
					never_show = {},
				},
			},
		},
	},
}
