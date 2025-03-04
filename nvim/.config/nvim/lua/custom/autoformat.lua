local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    quiet = true,
    formatters_by_ft = {
      lua = { "stylua" },
      php = { "pint" },
      javascript = {},
      typescript = {},
      vue = {},
      ["*"] = { "trim_whitespace" },
    },

    format_on_save = {
      lsp_format = "never",
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
