return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      require('nvim-treesitter').install {
        "javascript", "typescript", "php", "lua", "rust", "html", "vue", "jsdoc", "c", "vimdoc", "bash"
      }
    end,
  },
}
