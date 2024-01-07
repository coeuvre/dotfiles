vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-q>", ":bo cwindow<cr>")
vim.keymap.set("n", "<F5>", ":make<cr>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "]q", ":cnext<CR>zz")
vim.keymap.set("n", "[q", ":cprev<CR>zz")

vim.keymap.set("n", "]t", ":tabn<CR>zz")
vim.keymap.set("n", "[t", ":tabp<CR>zz")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

return {
    quickfix = {
        setup = function(e)
            local opts = { buffer = e.buf }
            vim.keymap.set("n", "q", ":cclose<cr>", opts)
        end,
    },

    lsp = {
        setup = function(e)
            local builtin = require("telescope.builtin")
            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = e.buf }
            vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
            vim.keymap.set("n", "gr", builtin.lsp_references, opts)
            vim.keymap.set("n", "K", require("hover").hover, opts)
            vim.keymap.set("n", "<F2>", ":IncRename ", opts)
            vim.keymap.set("n", "<A-Cr>", vim.lsp.buf.code_action, opts)
            if vim.lsp.buf.range_code_action then
                vim.keymap.set("x", "<A-Cr>", vim.lsp.buf.range_code_action)
            else
                vim.keymap.set("x", "<A-Cr>", vim.lsp.buf.code_action)
            end
            vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
        end,
    },
}
