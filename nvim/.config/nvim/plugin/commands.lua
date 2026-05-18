local function find_project_dir(marker)
  local found = vim.fs.find(marker, { upward = true, path = vim.fn.expand("%:h") })
  return found[1] and vim.fs.dirname(found[1]) or nil
end

-- :cexpr system('vendor/bin/phpstan analyse --no-progress --error-format=raw')<cr>
vim.api.nvim_create_user_command('ZZPhpStan', function(opts)
  local dir = opts.args ~= "" and opts.args or find_project_dir("composer.json")
  if dir then vim.cmd("lcd " .. dir) end
  vim.api.nvim_command('cexpr system(\'vendor/bin/phpstan analyse --no-progress --error-format=raw\')')
  vim.api.nvim_command('copen')
  if dir then vim.cmd("lcd -") end
end, { desc = "Analyse php and open quickfix list", nargs = "?" })

vim.api.nvim_create_user_command("ZZEslint", function(opts)
  local dir = opts.args ~= "" and opts.args or find_project_dir("package.json")
  if dir then vim.cmd("lcd " .. dir) end
  vim.opt.makeprg = "npx eslint -f unix ."
  vim.cmd("make")
  vim.cmd("copen")
  if dir then vim.cmd("lcd -") end
end, { desc = "Lint project with eslint and open quickfix", nargs = "?" })

vim.api.nvim_create_user_command("ZZVueTsc", function(opts)
  local dir = opts.args ~= "" and opts.args or find_project_dir("package.json")
  local prev_makeprg = vim.o.makeprg
  local prev_efm = vim.o.errorformat
  if dir then vim.cmd("lcd " .. dir) end
  vim.o.makeprg = "npx vue-tsc --noEmit --pretty false"
  vim.o.errorformat = "%f(%l\\,%c): %m"
  vim.cmd("make")
  vim.cmd("copen")
  if dir then vim.cmd("lcd -") end
  vim.o.makeprg = prev_makeprg
  vim.o.errorformat = prev_efm
end, { desc = "Type-check Vue project with vue-tsc and open quickfix", nargs = "?" })