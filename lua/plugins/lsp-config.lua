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
		"p00f/clangd_extensions.nvim",
		lazy = true,
		-- config = function() end,
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
				--These require codicons (https://github.com/microsoft/vscode-codicons)
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},

				highlights = {
					detail = "Comment",
				},
			},
			memory_usage = {
				border = "none",
			},
			symbol_info = {
				border = "none",
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind.nvim",
		},
		config = function()
			local lspkind = require("lspkind")
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.recently_used,
						require("clangd_extensions.cmp_scores"),
						-- cmp.config.compare.kind,
						-- cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				formatting = {
					fields = { "abbr", "icon", "kind" }, --menu
					format = lspkind.cmp_format({
						maxwidth = {
							-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
							-- can also be a function to dynamically calculate max width such as
							menu = function()
								return math.floor(0.35 * vim.o.columns)
							end,
							-- menu = 50, -- leading text (labelDetails)
							abbr = 15, -- actual suggestion item
						},
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						before = function(entry, vim_item)
							-- ...
							return vim_item
						end,
					}),
				},

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
						border = "bold",
						col_offset = -1,
						scrollbar = false,
						scrolloff = 3,
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,Search:None",
					}),
					documentation = false,
					-- documentation = cmp.config.window.bordered({
					--     border = "solid",
					--     scrollbar = false,
					--     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,Search:None",
					-- }),
					side_padding = 0,
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
			vim.lsp.config("clangd", {
				-- capabilities = capabilities,
				root_markers = {
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac", -- AutoTools
					"Makefile",
					"configure.ac",
					"configure.in",
					"config.h.in",
					"meson.build",
					"meson_options.txt",
					"build.ninja",
					".git",
				},
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			})

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
			vim.keymap.set(
				"n",
				"<leader>ch",
				"<cmd>LspClangdSwitchSourceHeader<CR>",
				{ desc = "Switch Source/Header (C/C++)" }
			)
		end,
	},
}
