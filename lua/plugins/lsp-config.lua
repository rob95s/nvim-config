return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },

    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({

                enabled = function()
                    -- visada leisti cmdline
                    if vim.api.nvim_get_mode().mode == "c" then
                        return true
                    end
                    -- išjungti komentaruose
                    local context = require("cmp.config.context")
                    return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                end,

                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },

                window = {
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "NormalFloat:Pmenu,FloatBorder:FloatBorder,Search:None",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "NormalFloat:Pmenu,FloatBorder:FloatBorder,Search:None",
                    }),
                    side_padding = 1,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-l>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(), --.abort()
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require("luasnip").jumpable(-1) then
                            require("luasnip").jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
            -- Set up lspconfig.
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })
            vim.lsp.config("clangd", { capabilities = capabilities })
            vim.lsp.config("bashls", { capabilities = capabilities })
            vim.lsp.enable({ "lua_ls", "clangd", "bashls" })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "List references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
        end,
    },
}
