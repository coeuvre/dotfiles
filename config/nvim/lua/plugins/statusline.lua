return function(use)
  use {
    "nvim-lualine/lualine.nvim",
    after = "nvim-web-devicons",
    config = function()
      require("lualine").setup({
        options = {
          component_separators = "",
          section_separators = "",
          theme = "onedark",
        },
        extensions = { "nvim-tree" }
      })
    end,
  }
end
