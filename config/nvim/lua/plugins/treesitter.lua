return function(use)
  use {
    "nvim-treesitter/nvim-treesitter",
    event = {"BufRead", "BufNewFile"},
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
        },
        highlight = {
          enable = true,
          use_languagetree = true,
        },
      })
    end,
  }
end
