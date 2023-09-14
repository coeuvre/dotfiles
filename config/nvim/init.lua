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
vim.o.cursorline = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

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

    {
        "okuuva/auto-save.nvim",
        cmd = "ASToggle",
        event = { "InsertLeave", "TextChanged" },
        -- TODO: Cancel delayed save if buf is being formatted
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme catppuccin")
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
                lualine_b = { "diagnostics" },
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
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = { enable = true },
                indent = { enable = true },
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
            })
        end,
    },
    {
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
                filetype = {
                    lua = {
                        require("formatter.filetypes.lua").stylua,
                    },
                },
            })
            vim.keymap.set("n", "==", function()
                vim.cmd("Format")
            end)
        end,
    },
}

require("lazy").setup(plugins)
