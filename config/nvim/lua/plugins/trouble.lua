return function(use)
  use {
    "folke/trouble.nvim",

    setup = function()
      local map = require("core.utils").map
      map("n", "<leader>xx", "<cmd>Trouble<cr>")
      map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
      map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
      map("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
      map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
    end,

    config = function()
      require("trouble").setup({})
    end
  }
end
