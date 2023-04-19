return {
  {
    "Mofiqul/vscode.nvim",
    name = "vscode",
    config = function()
      vim.o.background = "dark"
      require("vscode").setup({})
      require("vscode").load()
    end,
  },
}
