-- lua/colorscheme-picker/init.lua
vim.api.nvim_create_user_command("SetColorscheme", function()
	require("colorscheme-picker.window.floating-win").open()
end, {})

local persist = require("colorscheme-picker.window.persist")

local M = {}

M.available = { "catppuccin", "kanagawa", "gruvbox" }

-- load saved or fallback
M.current = persist.load() or "gruvbox"

function M.setup()
	local name = M.current
	local ok, theme = pcall(require, "colorscheme-picker.colorscheme." .. name)

	if not ok or not theme or not theme.setup then
		vim.notify("Colorscheme not found: " .. name, vim.log.levels.ERROR)
		return
	end

	-- setup the colorscheme
	theme.setup()

	-- adjust floating window background&foreground color
    local SCALE = 0.9
	local utils = require("colorscheme-picker.utils")
	vim.api.nvim_set_hl(0, "NormalFloat", {
        foreground = utils.get_highlight_hex_code("Normal", "fg"),
        background = utils.scale_hl_color(SCALE, "NormalFloat", "bg")
    })
	vim.api.nvim_set_hl(0, "CmpItemAbbr", {
        foreground = utils.scale_hl_color(SCALE+0.2, "CmpItemAbbr", "fg")
    })
    vim.api.nvim_set_hl(0, "FloatBorder", {
        foreground =utils.get_highlight_hex_code("FloatBorder", "fg"),
        background =utils.scale_hl_color(SCALE, "FloatBorder", "bg"),
    })
end
function M.save()
	persist.save(M.current)
end

return M
