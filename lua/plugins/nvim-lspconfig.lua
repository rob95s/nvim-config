return {
	"neovim/nvim-lspconfig",
	lazy = false,
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
					diagnostics = { globals = { "vim" } },
					telemetry = { enable = false },
				},
			},
		})
		vim.lsp.enable("lua_ls")

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--completion-style=bundled",
      },
    })
		vim.lsp.enable("clangd")
	end,
}
