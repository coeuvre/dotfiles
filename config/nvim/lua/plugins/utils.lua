vim.g.tmux_navigator_no_mappings = 1

return {
    "mbbill/undotree",

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({})
        end,
    },

    {
        "christoomey/vim-tmux-navigator",
        keys = {
            {
                "<C-h>",
                function()
                    vim.cmd("TmuxNavigateLeft")
                end,
            },
            {
                "<C-j>",
                function()
                    vim.cmd("TmuxNavigateDown")
                end,
            },
            {
                "<C-k>",
                function()
                    vim.cmd("TmuxNavigateUp")
                end,
            },
            {
                "<C-l>",
                function()
                    vim.cmd("TmuxNavigateRight")
                end,
            },
        },
    },

    {
        "okuuva/auto-save.nvim",
        cmd = "ASToggle",
        event = { "InsertLeave", "TextChanged" },
        opts = {
            debounce_delay = 300,
            condition = function()
                -- don't save for special-buffers
                if vim.bo.buftype ~= "" then
                    return false
                end

                return vim.bo.modifiable
            end,
        },
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = {},
    },
}
