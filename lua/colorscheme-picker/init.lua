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

    theme.setup()
end

function M.save()
    persist.save(M.current)
end

return M
