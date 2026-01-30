local M = {}
local utils = require("colorscheme-picker.utils")

function M.setup()
    -- Colorscheme
    require("catppuccin").setup({
        flavor = "frappe", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            dark = "frappe",
        },
        transparent_background = false,
        float = {
            transparent = false,
            solid = false,    -- use solid styling for floating windows, see |winborder
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true,  -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false,  -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,    -- Force no italic
        no_bold = false,      -- Force no bold
        no_underline = false, -- Force no underline
        styles = {            -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
                ok = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
                ok = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            notify = false,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
        },
    })

    utils.set_separator_color("#babbf1")
    utils.set_lualine_theme("palenight")
    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
end

return M

