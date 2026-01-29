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

-- Prevent Vim from automatically inserting comment prefixes
-- when opening new lines, while keeping normal indentation behavior
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

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

-- On CursorHold, automatically show diagnostics in a floating window
-- under the cursor.
--
-- Before opening the diagnostic float, we check if there is already
-- a floating window with a zindex (e.g. completion menu, hover, etc.)
-- and skip opening a new one to avoid overlapping popups.
--
-- The diagnostic float:
--   - is scoped to the cursor position
--   - is non-focusable (does not steal focus)
--   - uses a rounded border
--   - automatically closes on cursor movement, insert actions,
--     buffer/window changes
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
			border = "rounded",
			close_events = {
				"CursorMoved",
				"CursorMovedI",
				"BufHidden",
				"InsertCharPre",
				"WinLeave",
			},
		})
	end,
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
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Lazy.nvim
require("lazy").setup("plugins")
require("colorscheme-picker").setup()


-- Visual mode commenting
local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
local toggle_linewise = require("Comment.api").toggle.linewise
vim.keymap.set("x", "<leader>c", function()
	vim.api.nvim_feedkeys(esc, "nx", false)
	toggle_linewise(vim.fn.visualmode())
end, { noremap = true, silent = true, desc = "Comment line" })
