vim.g.zig_fmt_autosave = 0

return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "folke/neodev.nvim",

        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "j-hui/fidget.nvim",
        "SmiteshP/nvim-navic",
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

        require("neodev").setup({})

        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})

        lspconfig.clangd.setup({
            autostart = false,
            capabilities = {
                offsetEncoding = "utf-16",
            },
        })

        lspconfig.tsserver.setup({})
        lspconfig.zls.setup({})
        lspconfig.rust_analyzer.setup({})
    end,
}
