return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
    },
    completion = {
      ghost_text = {
        enabled = false,
      },
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
