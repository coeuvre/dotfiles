return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "windwp/nvim-autopairs",
            opts = {},
        },
        { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    version = "v0.*",
    opts = {
        keymap = {
            preset = "super-tab",
        },
        signature = { enabled = true },
        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then
                    return require("luasnip").jumpable(filter.direction)
                end
                return require("luasnip").in_snippet()
            end,
            jump = function(direction)
                require("luasnip").jump(direction)
            end,
        },
        sources = {
            default = { "lsp", "path", "luasnip", "buffer" },
        },
    },
}
