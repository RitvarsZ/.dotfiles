-- :cexpr system('vendor/bin/phpstan analyse --no-progress --error-format=raw')<cr>
vim.api.nvim_create_user_command('PhpStan', function()
  vim.api.nvim_command('cexpr system(\'vendor/bin/phpstan analyse --no-progress --error-format=raw\')')
  vim.api.nvim_command('copen')
end, { desc = "analyse php and open quickfix list", nargs = '*' })
