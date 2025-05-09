return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  priority = 100,
  dependencies = {
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("lspkind").init {}

    local cmp = require "cmp"
    local luasnip = require "luasnip"

    require("luasnip.loaders.from_vscode").lazy_load()

    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    cmp.setup {
      preselect = "item",
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      window = {
        documentation = cmp.config.window.bordered(),
      },
      sources = cmp.config.sources({
        { name = "path" },
        {
          name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            -- log ctx

            -- Ignore Text suggestions
            return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
          end,
        },
        { name = "nvim_lua" },
        { name = "luasnip", keyword_length = 2 },
      }, {
        { name = "buffer", keyword_length = 3 },
      }),
      mapping = cmp.mapping.preset.insert {
        -- confirm completion item
        ["<CR>"] = cmp.mapping.confirm { select = false },

        -- toggle completion menu
        ["<C-e>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end, { "i" }),

        -- tab complete
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- navigate between snippet placeholder
        ["<C-d>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-b>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- scroll documentation window
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
    }
  end,
}
