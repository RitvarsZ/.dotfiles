local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

vim.keymap.set('n', '<C-p>', function()
    builtin.git_files({ recurse_submodules = true })
end, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({
        search = vim.fn.input("Grep > "),
        search_dirs = vim.fn['getcwd']() .. "/**"
    })
end)
