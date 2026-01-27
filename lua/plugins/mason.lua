return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
	},
}
