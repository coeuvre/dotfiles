return function(use)
  use "christoomey/vim-tmux-navigator"
  use {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = { "NvimTree" }
    end,
  }
end
