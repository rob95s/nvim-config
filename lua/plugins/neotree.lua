return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false,             -- neo-tree will lazily load itself
        keys = {
            {
                "<C-n>",
                ":Neotree filesystem reveal left<CR>",
                desc = "Open Neotree (left)",
                silent = true,
            },
            {
                "<C-f>",
                ":Neotree filesystem reveal float<CR>",
                desc = "Open Neotree (float)",
                silent = true,
            },
        },
        opts = {
            filesystem = {
                filtered_items = {
                    visible = true,
                    show_hidden_cout = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {
                        ".git",
                    },
                    never_show = {},
                },
            },
        },
    },
}
