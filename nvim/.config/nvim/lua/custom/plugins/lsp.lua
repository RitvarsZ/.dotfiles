return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local lspconfig = require "lspconfig"

      require("mason").setup()
      -- This is for ts_ls
      -- see: https://github.com/vuejs/language-tools
      -- * god i love js...
      local mason_registry = require "mason-registry"
      local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"

      local servers = {
        -- Lint project and open problems in quickfix list :)
        -- :set makeprg=npx\ eslint\ -f\ unix\ .
        -- :make
        -- :copen
        eslint = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
          settings = {
            eslint = {
              -- autoFixOnSave = true, -- does this even do anything?
              format = {
                enable = true,
              },
            },
          },
        },
        bashls = true,
        lua_ls = {
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
              return
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- Depending on the usage, you might want to add additional paths here.
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
        intelephense = true,
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                extraEnv = {
                  CARGO_TARGET_DIR = "target/rust-analyzer",
                },
              },
              check = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        cssls = true,
        marksman = true,

        -- Probably want to disable formatting for this lang server
        ts_ls = {
          settings = {
            -- disable formatting because we use eslint.
            javascript = {
              format = { enable = false },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
              },
            },
            typescript = {
              format = { enable = false },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
              },
            },
          },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },

        tailwindcss = true,
        volar = {
          vue = {
            format = {
              template = { initialIndent = false },
              wrapAttributes = "preserve",
            },
          },
        },
        emmet_language_server = true,
        emmet_ls = true,

        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      local ensure_installed = {
        "lua_ls",
        "volar",
        "eslint",
        "intelephense",
        "ts_ls",
        "rust_analyzer",
        "marksman",
        "html",
        "emmet_language_server",
        "emmet_ls",
        "dockerls",
        "docker_compose_language_service",
        "clangd",
        "bashls",
        "phpstan",
        "pint",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end

        lspconfig[name].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
          vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
          end, { buffer = 0 })

          vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
          vim.keymap.set("n", "<space>]", vim.diagnostic.goto_next)
          vim.keymap.set("n", "<space>[", vim.diagnostic.goto_prev)

          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
        end,
      })

      -- auto format on save
      require("custom.autoformat").setup()

      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        virtual_text = {
          prefix = "",
        },
        severity_sort = true,
        float = {
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      }
    end,
  },
}
