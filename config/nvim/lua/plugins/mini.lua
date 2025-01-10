return {
    "echasnovski/mini.nvim",
    version = false,

    config = function()
        require("mini.basics").setup({
            options = {
                extra_ui = true,
            },
            mappings = {
                windows = true,
            },
        })
        require("mini.icons").setup()

        require("mini.ai").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()

        require("mini.bracketed").setup()
        require("mini.comment").setup()

        require("mini.diff").setup({
            view = {
                style = "sign",
            },
        })
        require("mini.git").setup()
        require("mini.statusline").setup()

        require("mini.files").setup()
        require("mini.pick").setup({
            window = {
                config = function()
                    return {
                        width = vim.o.columns,
                    }
                end,
            },
        })

        require("mini.extra").setup()
    end,
}
