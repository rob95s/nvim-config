-- lua/colorscheme-picker/window/floating-win.lua
local M = {}
local api = vim.api
local picker = require("colorscheme-picker")

-- namespace for highlight
M.ns = api.nvim_create_namespace("ColorschemePickerWin")

local WIDTH_PADDING = 20

function M.open()
    -- rasti ilgiausią schemos pavadinimą
    local max_len = 0
    for _, name in ipairs(picker.available) do
        max_len = math.max(max_len, #name)
    end
    local width = max_len + WIDTH_PADDING

    -- paruošti eilutes su centruotu tekstu
    local lines = {}
    for _, name in ipairs(picker.available) do
        local pad = width - #name
        local left = math.floor(pad / 2)
        local right = pad - left
        table.insert(lines, string.rep(" ", left) .. name .. string.rep(" ", right))
    end

    -- sukurti buffer
    local buf = api.nvim_create_buf(false, true)

    -- padaryti read-only
    api.nvim_buf_set_option(buf, "buftype", "nofile")
    api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    api.nvim_buf_set_option(buf, "swapfile", false)

    -- laikinai leidžiam įrašyti lines
    api.nvim_buf_set_option(buf, "modifiable", true)
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, "modifiable", false)

    -- paimam FloatBorder foreground foreground
    -- local border_hl = vim.api.nvim_get_hl_by_name("FloatBorder", true)
    -- local border_hl = vim.api.nvim_get_hl_by_name("Pmenu", true)
    -- local fg_color = string.format("#%06x", border_hl.foreground)
    -- local bg_color = string.format("#%06x", border_hl.background)
    -- vim.api.nvim_set_hl(0, "FloatTitle", { fg = fg_color, bg = bg_color, bold = true})


    local fg_rgb = vim.api.nvim_get_hl_by_name("FloatBorder", true).foreground
    local bg_rgb = vim.api.nvim_get_hl_by_name("FloatBorder", true).background
    local fg_hex = string.format("#%06x", fg_rgb)
    local bg_hex = string.format("#%06x", bg_rgb)
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = fg_hex, bg = bg_hex, bold = true})

    -- atidarom langą
    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = #lines,
        row = 5,
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Pick your colorscheme ",
        title_pos = "center",
    })


    -- įrašyti buffer ir window
    M.buf = buf
    M.win = win

    -- po atidarymo, atstatom seną FloatTitle
    -- vim.api.nvim_set_hl(0, "FloatTitle", old)

    local opts = { noremap = true, silent = true }

    -- keymaps judėjimui per eilutes
    local function map_move(key, delta)
        api.nvim_buf_set_keymap(
            buf,
            "n",
            key,
            string.format("<cmd>lua require('colorscheme-picker.window.floating-win').move_cursor(%d)<CR>", delta),
            opts
        )
    end

    map_move("j", 1)
    map_move("k", -1)
    map_move("<Down>", 1)
    map_move("<Up>", -1)

    -- keymap: pasirinkimas Enter
    api.nvim_buf_set_keymap(
        buf,
        "n",
        "<CR>",
        [[<cmd>lua require("colorscheme-picker.window.floating-win").select()<CR>]],
        opts
    )

    -- keymap: uždaryti langą Esc
    api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<cmd>lua vim.api.nvim_win_close(0, true)<CR>]], opts)

    -- pradinė highlight pozicija ant pirmos entry
    api.nvim_win_set_cursor(win, { 1, 0 })
    M.update_highlight()
end

-- judėti per eilutes
function M.move_cursor(delta)
    if not M.buf or not M.win then
        return
    end
    local row = api.nvim_win_get_cursor(M.win)[1] - 1
    row = math.max(0, math.min(row + delta, #picker.available - 1))
    api.nvim_win_set_cursor(M.win, { row + 1, 0 })
    M.update_highlight()
end

-- update highlight pagal cursor poziciją
function M.update_highlight()
    if not M.buf or not M.win then
        return
    end
    local row = api.nvim_win_get_cursor(M.win)[1] - 1
    api.nvim_buf_clear_namespace(M.buf, M.ns, 0, -1)
    api.nvim_buf_add_highlight(M.buf, M.ns, "Visual", row, 0, -1)
end

-- pasirinkti schemą po Enter
function M.select()
    if not M.buf or not M.win then
        return
    end

    local row = api.nvim_win_get_cursor(M.win)[1] - 1
    local raw = api.nvim_buf_get_lines(M.buf, row, row + 1, false)[1]
    if not raw then
        return
    end

    -- pašalinti padding tarpus
    local name = raw:match("^%s*(.-)%s*$")

    picker.current = name
    picker.setup()
    picker.save()

    api.nvim_win_close(M.win, true)
end

return M
