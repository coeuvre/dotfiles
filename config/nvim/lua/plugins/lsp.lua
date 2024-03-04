vim.g.zig_fmt_autosave = 0

return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        "j-hui/fidget.nvim",
        "smjonas/inc-rename.nvim",

        "lewis6991/hover.nvim",
        "ray-x/lsp_signature.nvim",
    },

    config = function()
        require("mason").setup({})
        require("mason-lspconfig").setup({})
        require("inc_rename").setup({
            input_buffer_type = "dressing",
        })
        require("fidget").setup({})
        require("lsp_signature").setup({
            hint_enable = false,
        })
        require("hover").setup({
            init = function()
                require("hover.providers.lsp")
            end,
            preview_opts = {
                border = "single",
            },
            preview_window = false,
            title = false,
        })

        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
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

        lspconfig.clangd.setup({
            autostart = false,
            capabilities = {
                offsetEncoding = "utf-16",
            },
        })

        lspconfig.tsserver.setup({})
        lspconfig.zls.setup({})
        lspconfig.rust_analyzer.setup({})
    end,
}
