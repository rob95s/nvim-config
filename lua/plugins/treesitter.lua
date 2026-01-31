return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Nvim-Treesitter
			require("nvim-treesitter").install({ "lua", "c", "awk", "bash" })
			function _G.custom_foldtext()
				local line = vim.fn.getline(vim.v.foldstart)
				local count = vim.v.foldend - vim.v.foldstart + 1
				return string.format("󰍟 %s (%d lines)", vim.trim(line), count)
			end

			vim.opt.fillchars = {
				fold = " ",
				foldsep = " ",
			}
			vim.opt.foldtext = "v:lua.custom_foldtext()"
			-- fold with keys 'zc'
			-- unfold with keys 'zo'
		end,
	},
}
