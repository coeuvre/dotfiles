return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
    },
    fuzzy = {
      max_typos = function()
        return 0
      end,
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    signature = { enabled = true },
  },
}
