local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    quiet = true,
    formatters_by_ft = {
      lua = { "stylua" },
      php = { "pint" },
      -- if vim.bo.filetype == 'javascript' or vim.bo.filetype == 'typescript' or vim.bo.filetype == 'vue' then
      -- disable formtting because eslint.
      javascript = nil,
      typescript = nil,
      vue = nil,
    },

    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
    formatters = {
      stylua = {
        cwd = require("conform.util").root_file { "stylua.toml" },
        require_cwd = true,
      },
      pint = {
        cwd = require("conform.util").root_file { "pint.json" },
        require_cwd = true,
      },
    },
  }

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
    },
  }
end

setup()

return { setup = setup }
