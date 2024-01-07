return {
    "mhartington/formatter.nvim",

    config = function()
        local clangforamt = require("formatter.defaults.clangformat")
        local prettier = require("formatter.defaults.prettier")

        require("formatter").setup({
            filetype = {
                lua = {
                    require("formatter.filetypes.lua").stylua,
                },
                c = { clangforamt },
                cpp = { clangforamt },
                javascript = { prettier },
                typescript = { prettier },
                zig = { require("formatter.filetypes.zig").zigfmt },
            },
        })
        vim.keymap.set("n", "<leader>f", function()
            vim.cmd(":silent! write") -- Cancel pending auto-save
            vim.cmd("FormatWrite")
        end)
    end,
}
