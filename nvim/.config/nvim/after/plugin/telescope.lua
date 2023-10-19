require('telescope').setup{}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

vim.keymap.set('n', '<C-p>', function()
    builtin.git_files({ recurse_submodules = true })
end, {})

