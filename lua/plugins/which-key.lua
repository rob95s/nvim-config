return {
	"folke/which-key.nvim",
	dependencies = { "nvim-mini/mini.nvim", version = "*" },
	event = "VeryLazy",
	config = function()
		-- require which-key
		local wk = require("which-key")
		-- Normalus setup, jei dar nepadaryta
		wk.setup({
			win = {
				width = 35,
				col = math.huge,
				height = { min = 10, max = 30 },
				border = "rounded",
				padding = { 0, 0 },
				wo = {
					winblend = 0,
				},
			},
			layout = {
				width = { min = 100, max = 100 },
				spacing = 1,
			},
	        triggers = {"<leader>"}, -- or specify a list manually
			plugins = {
				marks = true, -- rodo marks
				registers = true, -- rodo registrus
				spelling = { -- rodo spell suggestions
					enabled = true,
					suggestions = 20,
				},
			},
			icons = {
				breadcrumb = "»", -- navigacijos breadcrumb
				separator = "➜",
				group = "+",
			},
		})

		-- -- Paspaudus <leader>?, atidaro visus leader keybindus
		-- vim.keymap.set("n", "<leader>?", function()
		-- 	-- show all leader keymaps registered with which-key
		-- 	wk.show(nil, { mode = "n", prefix = "<leader>" })
		-- end, { desc = "Show all leader keybinds" })

		-- Optional: jei nori, gali padaryti ir visus keybindus visais prefixais
		vim.keymap.set("n", "<leader>?", function()
			wk.show()
		end, { desc = "Show all which-key keybinds" })
	end,
	-- opts = {
	--     -- your configuration comes here
	--     -- or leave it empty to use the default settings
	--     -- refer to the configuration section below
	--
	--     win = {
	--         width = 35,
	--         col = math.huge,
	--         height = { min = 10, max = 30 },
	--         border = "rounded",
	--         padding = { 0, 0 },
	--         wo = {
	--             winblend = 0,
	--         },
	--     },
	--     layout = {
	--         width = { min = 100, max = 100 },
	--         spacing = 1,
	--     },
	--     -- triggers = { "auto" }, -- automatically setup triggers
	--     -- triggers = {"<leader>"} -- or specify a list manually
	--     keys = {
	--         scroll_down = "<C-d>", -- binding to scroll down inside the popup
	--         scroll_up = "<C-u>", -- binding to scroll up inside the popup
	--     },
	-- },
	-- keys = {
	--     {
	--         "<leader>?",
	--         function()
	--             require("which-key").show({ global = false })
	--         end,
	--     },
	--     {
	--         "<leader>dt",
	--         function()
	--             require("dap").toggle_breakpoint()
	--         end,
	--         desc = "Toggle Breakpoint",
	--         nowait = true,
	--         remap = false,
	--     },
	-- },
}

-- {
--     "<leader>dt",
--     function()
--         require("dap").toggle_breakpoint()
--     end,
--     desc = "Toggle Breakpoint",
--     nowait = true,
--     remap = false,
-- },
