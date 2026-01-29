return {
    {
        "nvimdev/dashboard-nvim",
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
            local ascii_art = {
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                "                                                   ",
            }
            require("dashboard").setup({
                config = {
                    header = ascii_art,
                    -- čia gali pridėti custom buttons, jei nori
                    center = {},
                    footer = {},
                    shortcut = {},
                    packages = {
                        enable = false,
                    },
                },
            })
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
}
