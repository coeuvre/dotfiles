return function(use) 
  use {
    "navarasu/onedark.nvim",

    config = function()
      require('onedark').load()
    end,
  }
end
