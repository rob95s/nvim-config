local M = {}
local utils = require("colorscheme-picker.utils")

function M.setup()
	-- Default options:
	require("kanagawa").setup({
		compile = false, -- enable compiling the colorscheme
		undercurl = false, -- enable undercurls
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = { bold = true },
		typeStyle = {},
		transparent = false, -- do not set background color
		dimInactive = true, -- dim inactive window `:h hl-NormalNC`
		terminalColors = true, -- define vim.g.terminal_color_{0,17}
		colors = { -- add/modify theme and palette colors
			palette = {},
			theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
		},
		overrides = function(colors) -- add/modify highlights
			return {}
		end,
		theme = "wave", -- Load "wave" theme
		background = { -- map the value of 'background' option to a theme
			dark = "dragon", -- try "dragon" !
			light = "lotus",
		},
	})
    utils.set_lualine_theme("jellybeans")
    utils.set_separator_color("#F5E3C2")

	-- setup must be called before loading
	vim.cmd.colorscheme("kanagawa-wave")
end

return M
