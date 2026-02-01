local M = {}
local utils = require("colorscheme-picker.utils")

function M.setup()
	-- Default options:
	require("gruvbox").setup({
		terminal_colors = true, -- add neovim terminal colors
		undercurl = true,
		underline = true,
		bold = true,
		italic = {
			strings = true,
			emphasis = true,
			comments = true,
			operators = false,
			folds = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		inverse = true, -- invert background for search, diffs, statuslines and errors
		contrast = "soft", -- can be "hard", "soft" or empty string
		palette_overrides = {
			dark0_soft = "#32302f",
		},
		overrides = {
			TabLine = { fg = "#bdae93", bg = "#665c54" },
			TabLineFill = { fg = "#a89984", bg = "#1d2021" },
			TabLineSel = { fg = "#83a598", bg = "#504945" },
        },
		dim_inactive = false,
		transparent_mode = false,
	})

	utils.set_separator_color("#bdae93")
	utils.set_lualine_theme("gruvbox_dark")
	-- setup must be called before loading
	vim.o.background = "dark"
	vim.cmd.colorscheme("gruvbox")
	-- vim.api.nvim_set_hl(0, "TabLine", {fg = "#bdae93", bg = "#665c54"})
end

return M
