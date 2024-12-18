return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "windwp/nvim-autopairs",
            opts = {},
        },
    },
    version = "v0.*",
    opts = {
        keymap = { preset = "super-tab" },
        appearance = {
            nerd_font_variant = "mono",
        },
        signature = { enabled = true },
    },
}
