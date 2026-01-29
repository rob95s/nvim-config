-- nvim/lua/colorscheme-picker/utils.lua
-- Utility module for colorschemes
-- Provides helper functions shared across colorschemes/plugins

local M = {}

-- Table storing dynamic parameters
M._params = {
    separator_color = "#000000", -- default
    lualine_theme    = "auto",   -- default
}

-- Generic getter
function M.get_param(name)
    return M._params[name]
end

-- Generic setter
function M.set_param(name, value)
    M._params[name] = value
end

-- Convenience functions for separator color
function M.get_separator_color()
    return M.get_param("separator_color")
end

function M.set_separator_color(color)
    M.set_param("separator_color", color)
end

-- Convenience functions for lualine theme
function M.get_lualine_theme()
    return M.get_param("lualine_theme")
end

function M.set_lualine_theme(theme)
    M.set_param("lualine_theme", theme)
end

return M
