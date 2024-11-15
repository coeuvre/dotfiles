vim.g.tmux_navigator_no_mappings = 1

return {
    -- auto detect shiftwidth, expandtab, etc.
    "tpope/vim-sleuth",
    "mbbill/undotree",

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = { enable = true, additional_vim_regex_highlighting = false },
            })
        end,
    },

    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = { enabled = false },
                char = { keys = { "f", "F", "t", "T" } },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "o", "x" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
        },
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
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true })

                    map("n", "<leader>gd", gs.preview_hunk)
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = true })
                    end)
                end,
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = {},
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "catppuccin",
                component_separators = "",
                section_separators = "",
                globalstatus = true,
            },
            sections = {
                lualine_b = {},
                lualine_c = {
                    { "filename", path = 1 },
                    { "navic" },
                },
            },
        },
    },
}
