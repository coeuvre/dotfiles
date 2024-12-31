vim.g.zig_fmt_autosave = 0

return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "j-hui/fidget.nvim",
        "SmiteshP/nvim-navic",

        "saghen/blink.cmp",

        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },

    config = function()
        require("mason").setup({})
        require("mason-lspconfig").setup({})
        require("fidget").setup({})
        require("nvim-navic").setup({
            lsp = {
                auto_attach = true,
            },
        })

        local servers = {
            lua_ls = {},

            clangd = {
                autostart = false,
                capabilities = {
                    offsetEncoding = "utf-16",
                },
            },

            ts_ls = {},
            eslint = {},

            zls = {},

            rust_analyzer = {},

            pyright = {},
        }

        local lspconfig = require("lspconfig")
        for server, config in pairs(servers) do
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end
    end,
}
