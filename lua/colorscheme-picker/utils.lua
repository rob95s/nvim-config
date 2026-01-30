-- nvim/lua/colorscheme-picker/utils.lua
-- Utility module for colorschemes
-- Provides helper functions shared across colorschemes/plugins

local M = {}

-- Table storing dynamic parameters
M._params = {
    separator_color = "#000000", -- default
    lualine_theme = "auto",   -- default
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

function M.scale_hl_color(factor, hl_name, which)
    local hl = vim.api.nvim_get_hl_by_name(hl_name, true)
    if not hl then
        return nil
    end

    local color_val
    if which == "fg" and hl.foreground then
        color_val = hl.foreground
    elseif which == "bg" and hl.background then
        color_val = hl.background
    else
        return nil
    end

    local r = math.floor(color_val / 0x10000)
    local g = math.floor((color_val % 0x10000) / 0x100)
    local b = color_val % 0x100

    r = math.max(0, math.min(255, math.floor(r * factor)))
    g = math.max(0, math.min(255, math.floor(g * factor)))
    b = math.max(0, math.min(255, math.floor(b * factor)))

    return string.format("#%02x%02x%02x", r, g, b)
end

function M.get_highlight_hex_code(hl_name, switch)
    local hl_table = vim.api.nvim_get_hl_by_name(hl_name, true)
    -- print("Visas table -> " .. vim.inspect(hl_table)) -- čia pamatysi visą table
    local color_rgb
    if switch == "fg" then
        color_rgb = hl_table.foreground
    elseif switch == "bg" then
        color_rgb = hl_table.background
    end

    return string.format("#%06x", color_rgb)
end

return M
