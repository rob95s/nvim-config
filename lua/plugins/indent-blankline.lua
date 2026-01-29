return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        lazy = false,
        opts = function()
            require("ibl").setup({
                exclude = {
                    filetypes = {
                        "dashboard", -- tavo dashboard bufferis
                        "lspinfo",
                        "packer",
                        "checkhealth",
                        "help",
                        "man",
                        "gitcommit",
                        "TelescopePrompt",
                        "TelescopeResults",
                    },
                },
            })
        end,
    },
}
