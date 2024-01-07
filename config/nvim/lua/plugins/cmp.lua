vim.g.copilot_enabled = false
vim.g.copilot_assume_mapped = true

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        "onsails/lspkind.nvim",

        "github/copilot.vim",
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
}
