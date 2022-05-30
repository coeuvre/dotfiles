return function(use)
  use {
    "nvim-telescope/telescope.nvim",

    setup = function()
      local map = require("core.utils").map
      map("n", "<leader><leader>", [[<cmd>lua require("telescope.builtin").find_files()<cr>]])
      map("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").find_files()<cr>]])
      map("n", "<leader>fb", [[<cmd>lua require("telescope.builtin").buffers()<cr>]])
      map("n", "<leader>fo", [[<cmd>lua require("telescope.builtin").oldfiles()<cr>]])
      map("n", "<leader>fr", [[<cmd>lua require("telescope.builtin").resume()<cr>]])
      map("n", "<leader>fp", [[<cmd>lua require("telescope.builtin").pickers()<cr>]])
      map("n", "<leader>fw", [[<cmd>lua require("telescope.builtin").live_grep()<cr>]])
      map("n", "<leader>fh", [[<cmd>lua require("telescope.builtin").help_tags()<cr>]])
      map("n", "<leader>fd", [[<cmd>lua require("telescope.builtin").diagnostics()<cr>]])

      map("n", "gd", [[<cmd>lua require("telescope.builtin").lsp_definitions()<cr>]])
      map("n", "gD", [[<cmd>lua require("telescope.builtin").lsp_type_definitions()<cr>]])
      map("n", "gr", [[<cmd>lua require("telescope.builtin").lsp_references()<cr>]])
      map("n", "gi", [[<cmd>lua require("telescope.builtin").lsp_implementations()<cr>]])
    end,

    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = { ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble },
            n = { ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble },
          }
        }
      })
    end
  }
end
