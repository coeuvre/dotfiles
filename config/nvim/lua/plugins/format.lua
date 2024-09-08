return {
    "stevearc/conform.nvim",

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                html = { "prettier" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                zig = { "zigfmt" },
                rust = { "rustfmt" },
                sql = { "pg_format" },
            },
        })

        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
