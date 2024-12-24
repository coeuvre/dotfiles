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
        signature = { enabled = true },
    },
}
