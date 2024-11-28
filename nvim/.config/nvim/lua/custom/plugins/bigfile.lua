return {
  "LunarVim/bigfile.nvim",
  config = function ()
    require('bigfile').setup({
      filesize = 1,
      pattern = { "*" },
      features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    })
  end
}

