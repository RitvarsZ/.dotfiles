require('telescope').setup{}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

vim.keymap.set('n', '<C-p>', function()
    builtin.find_files({
        recurse_submodules = true,
        hidden = vim.fn.getcwd():match('.dotfiles') ~= nil,
    })
end, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.live_grep()
end, {})
