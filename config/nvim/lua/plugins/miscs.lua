return function(use)
  use "christoomey/vim-tmux-navigator"
  use {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end
  }
  use {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = { "NvimTree" }
    end,
  }
end
