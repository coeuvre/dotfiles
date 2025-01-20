return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
    },
    completion = {
      ghost_text = { enabled = false },
    },
    fuzzy = {
      use_typo_resistance = false,
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    signature = { enabled = true },
  },
}
