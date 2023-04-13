return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if vim.fn.has("win32") then
      opts.ensure_installed = {}
      return
    end

    -- workaroudn for https://github.com/LazyVim/LazyVim/issues/524
    opts.ignore_install = { "help" }

    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        "zig",
      })
    end
  end,
}
