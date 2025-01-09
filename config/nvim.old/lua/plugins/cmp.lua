return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    version = "v0.*",
    opts = {
        keymap = {
            preset = "super-tab",
        },
        signature = { enabled = true },
        sources = {
            default = { "lsp", "path", "buffer" },
        },
    },
}
