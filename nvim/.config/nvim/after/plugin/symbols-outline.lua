require("symbols-outline").setup()

vim.keymap.set('n', '<leader>fo', function()
    vim.cmd(":SymbolsOutline")
end, {})
