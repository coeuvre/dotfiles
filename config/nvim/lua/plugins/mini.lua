return {
    "echasnovski/mini.nvim",
    version = false,

    config = function()
        require("mini.basics").setup()
        require("mini.comment").setup()

        require("mini.ai").setup()
        require("mini.pairs").setup()
        require("mini.surround").setup()

        require("mini.bracketed").setup()
        require("mini.jump").setup()
        require("mini.jump2d").setup()

        require("mini.diff").setup({
            view = {
                style = "sign",
            },
        })
        require("mini.git").setup()
        require("mini.statusline").setup()
        require("mini.icons").setup()
    end,
}
