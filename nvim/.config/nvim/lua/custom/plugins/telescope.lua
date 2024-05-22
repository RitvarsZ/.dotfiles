return {
  'nvim-telescope/telescope.nvim', 
  tag = '0.1.7',
  -- or branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup{
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          "vendor/telescope",
          "vendor/horizon"
        },
      },
    }

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

    vim.keymap.set('n', '<C-p>', function()
      local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ";")
      if git_dir ~= "" then
        builtin.git_files({
          recurse_submodules = true,
        })
      else
        builtin.find_files({
          recurse_submodules = true,
        })
      end
    end, {})

    vim.keymap.set('n', '<leader>ps', function()
      builtin.live_grep({
        max_results = 1000,
        additional_args = function(opts)
          return {"--hidden"}
        end
      })
    end, {})
  end
}

