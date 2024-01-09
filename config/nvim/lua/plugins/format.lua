return {
    "stevearc/conform.nvim",

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettier" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                zig = { "zigfmt" },
            },
        })

        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
