return function(use) 
  use {
    "olimorris/onedarkpro.nvim",
    config = function()
      local onedark = require("onedarkpro")
      onedark.setup({
        options = {
          bold = true,
          italic = true,
          underline = true,
          undercurl = true,
          cursorline = true,
          terminal_colors = true,
        },
      })
      onedark.load()
    end,
  }
end
