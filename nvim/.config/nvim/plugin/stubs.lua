vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.php.stub", "*.php.*.stubpart" },
  callback = function()
    vim.bo.filetype = "php"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.js.stub", "*.js.*.stubpart" },
  callback = function()
    vim.bo.filetype = "javascript"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.ts.stub", "*.ts.*.stubpart" },
  callback = function()
    vim.bo.filetype = "typescript"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.vue.stub", "*.vue.*.stubpart" },
  callback = function()
    vim.bo.filetype = "vue"
  end,
})
