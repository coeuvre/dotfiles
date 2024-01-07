vim.g.tmux_navigator_no_mappings = 1

return {
    -- auto detect shiftwidth, expandtab, etc.
    "tpope/vim-sleuth",
    "farmergreg/vim-lastplace",
    "mbbill/undotree",

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true },
                matchup = { enable = true },
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    {
        "andymass/vim-matchup",
        opts = {},
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
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
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
    "sindrets/diffview.nvim",

    "nvim-tree/nvim-web-devicons",
    {
        "nvim-tree/nvim-tree.lua",
        opts = {},
        keys = {
            {
                "<C-b>",
                function()
                    require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
                end,
            },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                component_separators = "",
                section_separators = "",
                global_status = true,
            },
            sections = {
                lualine_b = {},
                lualine_c = {
                    {
                        "filename",
                        file_status = false,
                        path = 1,
                    },
                },
            },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = require("telescope.actions").close,
                            ["<C-x>"] = require("telescope.actions").close,
                        },
                    },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
            vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
            vim.keymap.set({ "n", "v" }, "<leader>*", builtin.grep_string, {})
        end,
    },

    {
        "numtostr/FTerm.nvim",
        keys = {
            {
                "<C-x>",
                mode = { "n", "t" },
                function()
                    require("FTerm").toggle()
                end,
                desc = "Floaterm",
            },
        },
        config = function()
            ---@type nil|string|table
            local cmd = os.getenv("SHELL")
            if vim.fn.has("win32") ~= 0 then
                cmd = {
                    "C:\\msys64\\usr\\bin\\fish.exe",
                    "--login",
                    "-i",
                }
                vim.env.CHERE_INVOKING = "1"
                vim.env.MSYS2_PATH_TYPE = "inherit"
            end
            require("FTerm").setup({
                cmd = cmd,
            })
        end,
    },
}
