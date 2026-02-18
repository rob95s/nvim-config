return {
	{
		"nvimdev/dashboard-nvim",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
		event = "VimEnter",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dashboard",
				callback = function()
					vim.schedule(function()
						require("ibl").setup_buffer(0, { enabled = false })
					end)
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dashboard",
				callback = function()
					vim.opt_local.fillchars:append({ eob = " " })
				end,
			})

			local fg_hi = vim.api.nvim_get_hl(0, { name = "Question" }).fg
			vim.api.nvim_set_hl(0, "DashboardHeader", { fg = fg_hi })

			local ascii_art = {
				"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
				"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
				"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
				"                                                   ",
				"                                                   ",
			}
			require("dashboard").setup({
				theme = "doom",
				config = {
					header = ascii_art,
					-- čia gali pridėti custom buttons, jei nori
					center = {
						-- {
						-- 	icon = "󰋒  ",
						-- 	icon_hl = "Character",
						-- 	desc = "Checkhealth                                ",
						-- 	desc_hl = "String",
						-- 	key = "h",
						-- 	key_hl = "Number",
						-- 	key_format = " %s", -- remove default surrounding `[]`
						-- 	-- keymap = "SPC f f",
						-- 	action = "checkhealth",
						-- },
						{
							icon = "  ",
							icon_hl = "Character",
							desc = "Open file $MYVIMRC                      ",
							desc_hl = "String",
							key = "m",
							key_hl = "Number",
							key_format = " %s", -- remove default surrounding `[]`
							-- keymap = "SPC f d",
							action = "e $MYVIMRC",
						},
						{
							icon = "  ",
							icon_hl = "Character",
							desc = "Open Neotree in '.config/nvim/'",
							desc_hl = "String",
							key = "c",
							key_hl = "Number",
							key_format = " %s", -- remove default surrounding `[]`
							-- keymap = "SPC f d",
							action = "Neotree float dir=~/.config/nvim",
						},
						{
							icon = "  ",
							icon_hl = "Character",
							desc = "Read Vim Tutor",
							desc_hl = "String",
							key = "rv",
							key_hl = "Number",
							key_format = " %s", -- remove default surrounding `[]`
							-- keymap = "SPC f d",
							action = "Tutor",
						},
						{
							icon = "  ",
							icon_hl = "Character",
							desc = "Read Lua-guide",
							desc_hl = "String",
							key = "rl",
							key_hl = "Number",
							key_format = " %s", -- remove default surrounding `[]`
							-- keymap = "SPC f d",
							action = "help Lua-guide",
						},
					},
					footer = {},
					vertical_center = true, -- Center the Dashboard on the vertical (from top to bottom)
					-- vertical_center = false, -- Center the Dashboard on the vertical (from top to bottom)
				},
			})
		end,
	},
}
