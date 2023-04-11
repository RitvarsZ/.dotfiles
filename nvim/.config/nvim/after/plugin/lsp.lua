local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

local nvim_lsp = require('lspconfig')

nvim_lsp.intelephense.setup {
    on_init = function(client)
    local path = client.workspace_folders[1].name

        if path == '~/projects/kirmada-deployments' then
            client.config.settings["intelephense"].environment.documentRoot = "web-backend/public"
            client.config.settings["intelephense"].environment.phpVersion = "7.4.29"
            client.config.settings["intelephense"].completion.fullyQualifyGlobalConstantsAndFunctions = true
        end

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        return true
    end,
    -- NOTE: you must spell out the config you wanna change in `on_init` inside `settings`, like:
    settings = {
        ['rust-analyzer'] = { checkOnSave = { overrideCommand = {} } } -- here
    }
}
