-- Add plugins here
return {

	{
		"catppuccin/nvim",
		name = "catppuccin",
		-- priority = 1000,
	},

	{
		"rebelot/kanagawa.nvim",
	},

	{
		"ellisonleao/gruvbox.nvim",
		-- priority = 1000,
		config = true,
		-- opts = ...
	},

	{
		"numToStr/Comment.nvim",
		opts = {
			mappings = false,
			-- add any options here
		},
	},
}
