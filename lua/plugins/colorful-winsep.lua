
return {
	"nvim-zh/colorful-winsep.nvim",
	config = true,
	event = { "WinLeave" },
	opts = {
		-- choose between "single", "rounded", "bold" and "double".
		-- Or pass a table like this: { "─", "│", "┌", "┐", "└", "┘" },
		border = { "━", "┃", "┏", "┓", "┗", "┛" },
		excluded_ft = {
          "mason",
          "lazy",
          "dashboard",
          "lspinfo",
          "packer",
          "checkhealth",
          "TelescopePrompt",
          "TelescopeResults",
        },
		-- highlight = nil, -- nil|string|function. See the docs's Highlights section
		-- highlight = vim.api.nvim_set_hl(0, "ColorfulWinSep", { fg = utils.get_separator_color(), bg = nil }),
        highlight = function()
            local hl = vim.api.nvim_get_hl(0, {name  = "Normal"})
            -- convert 24bit RGB integer to HEX
            local hl_hex_string = string.format("#%06x", hl.fg)
            vim.api.nvim_set_hl(0, "ColorfulWinSep", { fg = hl_hex_string, bg = nil })
        end,
        animate = {
			enabled = "shift", -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
			shift = {
				delta_time = 0.1,
				smooth_speed = 1,
				delay = 3,
			},
			progressive = {
				-- animation's speed for different direction
				vertical_delay = 2,
				horizontal_delay = 2,
			},
		},
		indicator_for_2wins = {
			-- only work when the total of windows is two
			position = false, -- false to disable or choose between "center", "start", "end" and "both"
			symbols = {
				-- the meaning of left, down ,up, right is the position of separator
				start_left = "󱞬",
				end_left = "󱞪",
				start_down = "󱞾",
				end_down = "󱟀",
				start_up = "󱞢",
				end_up = "󱞤",
				start_right = "󱞨",
				end_right = "󱞦",
			},
		},
	},
}
