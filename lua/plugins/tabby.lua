return {
    {
        "nanozuki/tabby.nvim",
        ---@type TabbyConfig
        config = function()
            local theme = {
                fill = "TabLineFill",
                -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
                head = "TabLine",
                current_tab = "TabLineSel",
                tab = "TabLine",
                win = "TabLine",
                tail = "TabLine",
                -- hl_red = "lualine_a_visual",
                hl_red = {
                    fg = "#e67e80",
                    -- fg = string.format("#%06x",vim.api.nvim_get_hl(0, {name = "lualine_a_visual"}).bg),
                    -- fg = vim.api.nvim_get_hl(0, { name = "lualine_a_visual" }).bg,
                    bg = "#4d5960",
                },
                hl_yellow = {
                    fg = "#d3c6aa",
                    bg = "#4d5960",
                },
                hl_green = {
                    fg = "#83c092",
                    -- fg = string.format("#%06x",vim.api.nvim_get_hl(0, {name = "lualine_a_command"}).bg),
                    bg = "#4d5960",
                },
            }
            require("tabby").setup({
                line = function(line)
                    local buf_is_changed_status = function()
                        local tabid = line.api.get_current_tab()
                        local winid = line.api.get_tab_current_win(tabid)
                        local bufid = line.api.get_win_buf(winid)
                        local result = {}

                        if vim.api.nvim_get_option_value("modifiable", {buf = bufid}) then
                            if line.api.get_buf_is_changed(bufid) then
                                result = { icon = " 󰈸 ", hl = theme.hl_red }
                            else
                                result = { icon = " 󰸞 ", hl = theme.hl_green }
                            end
                        else
                            result = { icon = "  ", hl = theme.hl_yellow }
                        end
                        return result
                    end

                    local active_file_dir = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~")

                    return {
                        {
                            { active_file_dir, hl = theme.tail },
                            line.sep("", theme.tail, theme.fill),
                        },

                        line.tabs().foreach(function(tab)
                            local hl = tab.is_current() and theme.current_tab or theme.tab
                            local tab_count = #vim.api.nvim_list_tabpages()
                            local tab_nr = tab.number()

                            -- jei ne PIRMAS tabas, tada bg spalvinam sviesiau
                            local theme_color = function()
                                if tab_nr < tab_count then
                                    return theme.tab
                                end
                                return theme.fill
                            end

                            -- jei PIRMAS tabas, tada tamsinam
                            local theme_color_first_tab = function()
                                if tab_nr == 1 then
                                    return theme.fill
                                else
                                    return theme.tab
                                end
                            end

                            return {
                                line.sep("", hl, theme_color_first_tab()),
                                tab.is_current() and " " or "",
                                (tab.number() == 1 and not tab.is_current()) and " " or "",
                                tab.number(),
                                (tab.number() == 1 and not tab.is_current()) and "" or " ",
                                line.sep("", hl, theme_color()),
                                hl = hl,
                                margin = "",
                            }
                        end),

                        line.spacer(),

                        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
                            local is_filetype_in_blacklist = function(ft, ft_blist)
                                for _, v in pairs(ft_blist) do
                                    if v == ft then
                                        return true
                                    end
                                end
                                return false
                            end

                            local filetype_blacklist = {
                                "checkhealth",
                                "neo-tree",
                            }

                            local buf_filetype = vim.api.nvim_get_option_value("filetype", { buf = win.buf().id })
                            if not is_filetype_in_blacklist(buf_filetype, filetype_blacklist) then
                                return {
                                    line.sep("", theme.win, theme.fill),
                                    win.is_current() and { "", hl = theme.hl_green },
                                    " " .. win.buf_name() .. " ",
                                    line.sep("", theme.win, theme.fill),
                                    hl = theme.win,
                                    margin = "",
                                }
                            end
                        end),

                        {
                            line.sep("", theme.tail, theme.fill),
                            { buf_is_changed_status().icon, hl = buf_is_changed_status().hl },
                        },
                    }
                end,
                -- option = {}, -- setup modules' option,
            })
        end,
    },
}
