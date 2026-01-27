return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.clang_format,
                -- null_ls.builtins.diagnostics.shellcheck, -- shell script diagnostics
                -- null_ls.builtins.code_actions.shellcheck, -- shell script code actions
            },
        })
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })
    end,
}
