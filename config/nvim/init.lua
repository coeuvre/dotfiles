-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
vim.o.clipboard = "unnamedplus"

vim.o.swapfile = false
vim.o.backup = false
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

vim.o.guifont = "JetBrainsMono NF:h11"

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "Q", "<nop>")

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
vim.g.zig_fmt_autosave = 0

vim.g.copilot_enabled = false
vim.g.copilot_assume_mapped = true

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
    "mbbill/undotree",
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
            vim.cmd.colorscheme("catppuccin")
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
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
        },
        config = function()
            local trouble = require("trouble.providers.telescope")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = require("telescope.actions").close,
                            ["<C-x>"] = require("telescope.actions").close,
                            ["<C-q>"] = trouble.open_with_trouble,
                        },
                    },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
            vim.keymap.set({ "n", "x" }, "<leader>*", builtin.grep_string, {})
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
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()

            local on_attach = function(client, bufnr)
                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
                vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
                vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr })
                vim.keymap.set("n", "gD", builtin.lsp_type_definitions, { buffer = bufnr })
                vim.keymap.set("n", "gi", builtin.lsp_implementations, { buffer = bufnr })
                vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })
                vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = bufnr })
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
                vim.keymap.set("n", "<A-Cr>", vim.lsp.buf.code_action, { buffer = bufnr })
                vim.keymap.set("i", "<C-Space>", vim.lsp.buf.signature_help, { buffer = bufnr })

                if vim.lsp.buf.range_code_action then
                    vim.keymap.set("x", "<A-Cr>", vim.lsp.buf.range_code_action)
                else
                    vim.keymap.set("x", "<A-Cr>", vim.lsp.buf.code_action)
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

            lspconfig.tsserver.setup({
                on_attach = on_attach,
            })

            lspconfig.zls.setup({
                on_attach = on_attach,
            })
        end,
    },
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup({
                init = function()
                    require("hover.providers.lsp")
                end,
                preview_opts = {
                    border = nil,
                },
                preview_window = true,
                title = false,
            })
        end,
    },

    { "github/copilot.vim" },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            "onsails/lspkind.nvim",
        },

        config = function()
            local luasnip = require("luasnip")
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            local confirm = function(fallback)
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
            end

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
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = {
                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            return
                        end

                        fallback()
                    end, { "i", "s" }),

                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            return
                        end

                        fallback()
                    end, { "i", "s" }),

                    ["<Cr>"] = cmp.mapping(confirm, { "i", "s" }),

                    ["<Tab>"] = cmp.mapping(confirm, { "i", "s" }),

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
                    { name = "path" },
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
                    zig = { require("formatter.filetypes.zig").zigfmt },
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
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local trouble = require("trouble")
            vim.keymap.set("n", "<leader>xx", function()
                trouble.open()
            end)
            vim.keymap.set("n", "<leader>xw", function()
                trouble.open("workspace_diagnostics")
            end)
            vim.keymap.set("n", "<leader>xd", function()
                trouble.open("document_diagnostics")
            end)
            vim.keymap.set("n", "<leader>xq", function()
                trouble.open("quickfix")
            end)
            vim.keymap.set("n", "<leader>xl", function()
                trouble.open("loclist")
            end)
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        config = function()
            ---@type nil|string|table
            if vim.fn.has("win32") ~= 0 then
                vim.o.shell= "C:\\msys64\\usr\\bin\\fish.exe"
                vim.o.shellcmdflag = "--login -i"
                vim.env.CHERE_INVOKING = "1"
                vim.env.MSYS2_PATH_TYPE = "inherit"
            end
            require("toggleterm").setup({
                open_mapping = "<C-x>",
                direction = "float",
            })
        end,
    },
}

require("lazy").setup(plugins)
