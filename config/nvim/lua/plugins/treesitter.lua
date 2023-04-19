return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if vim.fn.has("win32") then
      opts.ensure_installed = {}
      return
    end

    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        "zig",
      })
    end
  end,
}
