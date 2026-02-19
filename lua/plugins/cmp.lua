return {
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  -- { "hrsh7th/cmp-buffer" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "onsails/lspkind.nvim" },

  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
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
          -- documentation = false,
          documentation = cmp.config.window.bordered({
            border = "solid",
            scrollbar = false,
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,Search:None",
          }),
          side_padding = 0,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
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
        matching = {
          disallow_fuzzy_matching = true,
          disallow_partial_matching = true,
          disallow_prefix_unmatching = true,
        },
        performance = {
          max_view_entries = 20,
        },
        formatting = {
          fields = { 'abbr', 'icon', 'kind', 'menu' },
          format = lspkind.cmp_format({
            maxwidth = {
              -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              -- can also be a function to dynamically calculate max width such as
              -- menu = function() return math.floor(0.45 * vim.o.columns) end,
              menu = 50,        -- leading text (labelDetails)
              abbr = 50,        -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              -- ...
              return vim_item
            end
          })
        },
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
          },
          { name = "nvim_lua" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          -- { name = "buffer" },
        }),
      })
    end,
  },
}
