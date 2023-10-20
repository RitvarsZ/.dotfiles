-- todo: this dont work. Opens empty buffer instead
vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("UiEnter", {
    desc = "Open Neotree automatically",
    group = "neotree",
    callback = function()
        if vim.fn.argc() == 0 and not vim.fn.exists "s:std_in" then
            vim.cmd "Neotree toggle"
        end
    end,
})
