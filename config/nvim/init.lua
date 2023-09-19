-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.termguicolors = true
vim.o.wrap = false
vim.o.laststatus = 3
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

vim.keymap.set("n", "]b", function()
    vim.cmd("bnext")
end, {})
vim.keymap.set("n", "[b", function()
    vim.cmd("bprev")
end, {})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.tmux_navigator_no_mappings = 1

local plugins = {
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

    -- auto detect shiftwidth, expandtab, etc.
    "tpope/vim-sleuth",
    "farmergreg/vim-lastplace",
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

                    -- Navigation
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
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme catppuccin")
        end,
    },
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({})
        end,
    },
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
                    {
                        "navic",
                        color_correction = "static",
                    },
                },
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
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<A-p>", builtin.buffers, {})
            vim.keymap.set("n", "g/", builtin.live_grep, {})
            vim.keymap.set("n", "g*", builtin.grep_string, {})
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = { enable = true },
                indent = { enable = true },
                matchup = { enable = true },
            })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        opts = {
            highlight = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            "SmiteshP/nvim-navic",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()

            local navic = require("nvim-navic")

            local on_attach = function(client, bufnr)
                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr })
                vim.keymap.set("n", "gD", builtin.lsp_type_definitions, { buffer = bufnr })
                vim.keymap.set("n", "gi", builtin.lsp_implementations, { buffer = bufnr })
                vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })
                vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = bufnr })
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
                vim.keymap.set("n", "<A-cr>", vim.lsp.buf.code_action, { buffer = bufnr })
                vim.keymap.set("i", "<C-Space>", vim.lsp.buf.signature_help, { buffer = bufnr })

                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if
                        not vim.loop.fs_stat(path .. "/.luarc.json")
                        and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
                    then
                        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = "LuaJIT",
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME,
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    },
                                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                    -- library = vim.api.nvim_get_runtime_file("", true)
                                },
                            },
                        })

                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end
                end,
                on_attach = on_attach,
            })

            lspconfig.clangd.setup({
                capabilities = {
                    offsetEncoding = "utf-16",
                },
                on_attach = on_attach,
            })

            require("lspconfig").tsserver.setup({
                on_attach = on_attach,
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
        config = function()
            -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",

            "zbirenbaum/copilot.lua",
            "zbirenbaum/copilot-cmp",

            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            "onsails/lspkind.nvim",
        },

        config = function()
            local luasnip = require("luasnip")
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        symbol_map = { Copilot = "" },
                    }),
                },
                preselect = cmp.PreselectMode.Item,
                mapping = {
                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                            return
                        end

                        fallback()
                    end, { "i", "s" }),

                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            return
                        end

                        fallback()
                    end, { "i", "s" }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            end
                            cmp.confirm()
                            return
                        end

                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                            return
                        end

                        fallback()
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                            return
                        end

                        fallback()
                    end, { "i", "s" }),
                },
                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "buffer" },
                }),
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
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
                },
            })
            vim.keymap.set("n", "<leader>f", function()
                vim.cmd(":silent! write") -- Cancel pending auto-save
                vim.cmd("FormatWrite")
            end)
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    {
        "voldikss/vim-floaterm",
        keys = {
            {
                "<C-Space>",
                mode = { "n", "t" },
                function()
                    vim.cmd("FloatermToggle")
                end,
                desc = "Floaterm",
            },
        },
        config = function()
            vim.g.floaterm_width = 0.9
            vim.g.floaterm_height = 0.9
        end,
    },
}

require("lazy").setup(plugins)

vim.api.nvim_create_user_command("LoadCopilot", function()
    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })
    require("copilot_cmp").setup()
end, {})
