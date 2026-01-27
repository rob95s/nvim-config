vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.guicursor = ""
vim.opt.mouse = "a"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.smartindent = false
vim.opt.wrap = false
vim.opt.scrolloff = 7
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.guifont = "FiraCode Nerd Font:h14" -- GUI

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true


-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ką saugoti view'e (foldai, cursor pozicija ir t.t.)
vim.opt.viewoptions = { "folds", "cursor", "curdir" }

-- Išsaugoti view uždarant buferį
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*",
    command = "silent! mkview",
})

-- Atkurti view atidarant failą
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    command = "silent! loadview",
})

-- Opens Manual page on hovered word in .c files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    callback = function()
        vim.keymap.set("n", "<leader>k", function()
            local word = vim.fn.expand("<cword>")

            -- patikrinam ar egzistuoja man page
            local ok = vim.fn.system({ "man", "-w", word })
            if vim.v.shell_error ~= 0 then
                vim.notify(("No man page available for '%s'"):format(word), vim.log.levels.WARN)
                return
            end

            vim.cmd("Man " .. word)
        end, { buffer = true, desc = "C man page" })
    end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            border = "rounded";
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Move to left window" }))
vim.keymap.set("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Move to lower window" }))
vim.keymap.set("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Move to upper window" }))
vim.keymap.set("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Move to right window" }))

vim.keymap.set("n", "<F5>", ":w<CR>:!clang %:p -o %:p:r && %:p:r<CR>", { desc = "Run C code" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Lazy.nvim
require("lazy").setup("plugins")

-- Colorscheme
require("catppuccin").setup({
    flavor = "frappe", -- latte, frappe, macchiato, mocha
    background = {  -- :h background
        dark = "frappe",
    },
    transparent_background = false,
    float = {
        transparent = false,
        solid = false,       -- use solid styling for floating windows, see |winborder
    },
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false,     -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false,     -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,   -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,       -- Force no italic
    no_bold = false,         -- Force no bold
    no_underline = false,    -- Force no underline
    styles = {               -- Handles the styles of general hi groups (see `:h highlight-args`):
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
-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")


-- Nvim-Treesitter
require("nvim-treesitter").install({ "lua" })
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

-- Visual mode commenting
local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
local toggle_linewise = require("Comment.api").toggle.linewise
vim.keymap.set("x", "<leader>c", function()
    vim.api.nvim_feedkeys(esc, "nx", false)
    toggle_linewise(vim.fn.visualmode())
end, { noremap = true, silent = true, desc = "Comment line" })

-- Neotree
vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { silent = true, desc = "Open Neotree" })
vim.keymap.set("n", "<C-f>", ":Neotree filesystem reveal float<CR>", { silent = true, desc = "Open Neotree float" })

