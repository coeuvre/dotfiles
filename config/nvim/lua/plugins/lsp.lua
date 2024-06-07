vim.g.zig_fmt_autosave = 0

return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "j-hui/fidget.nvim",
        "SmiteshP/nvim-navic",
    },

    config = function()
        require("mason").setup({})
        require("mason-lspconfig").setup({})
        require("fidget").setup({})
        require("nvim-navic").setup({
            lsp = {
                auto_attach = true,
            },
        })

        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                    return
                end

                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
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
                            -- Depending on the usage, you might want to add additional paths here.
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        },
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    },
                })
            end,
            settings = {
                Lua = {},
            },
        })

        lspconfig.clangd.setup({
            autostart = false,
            capabilities = {
                offsetEncoding = "utf-16",
            },
        })

        lspconfig.tsserver.setup({
            autostart = false,
        })

        lspconfig.zls.setup({})

        lspconfig.rust_analyzer.setup({})
    end,
}
