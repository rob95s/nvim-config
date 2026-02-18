return {
	{
		"numToStr/Comment.nvim",
		-- opts = {
		-- 	mappings = false,
		-- 	-- add any options here
		-- },
		config = function()
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			local toggle_linewise = require("Comment.api").toggle.linewise
			vim.keymap.set("x", "<leader>c", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				toggle_linewise(vim.fn.visualmode())
			end, { noremap = true, silent = true, desc = "Comment line" })
		end,
	},
}
