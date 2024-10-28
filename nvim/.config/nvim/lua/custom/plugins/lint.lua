return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    -- Phpstan specific config for docker.
    local phpstan = require('lint').linters.phpstan

    local bin = "phpstan"
    phpstan.cmd = function ()
      local curpath = vim.fn.expand('%:p:h')
      -- find the root of the project (look for composer.json)
      local composerpath = vim.fn.findfile('composer.json', curpath .. ';')
      -- get abs path to project root.
      phpstan.cwd = vim.fn.fnamemodify(composerpath, ':p:h')

      local local_bin = vim.fn.fnamemodify('vendor/bin/' .. bin, ':p')
      if vim.loop.fs_stat(local_bin) then
        return local_bin
      end

      return bin
    end

    lint.linters_by_ft = {
      php = { "phpstan" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}

