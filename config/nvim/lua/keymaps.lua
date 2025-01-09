vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-q>", ":ToggleQuickfix<cr>", { silent = true })
vim.keymap.set("n", "<leader>b", ":wa <bar> AsyncTask build<cr>")
vim.keymap.set("n", "<F5>", ":AsyncTask run<cr>")

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({})
end)

vim.keymap.set("n", "<C-b>", ":lua MiniFiles.open()<cr>", { silent = true })

vim.keymap.set("n", "<C-p>", ":lua MiniPick.builtin.files()<cr>", { silent = true })
vim.keymap.set("n", "<leader><leader>", ":lua MiniPick.builtin.buffers()<cr>", { silent = true })
vim.keymap.set("n", "<leader>r", ":lua MiniPick.builtin.resume()<cr>", { silent = true })
vim.keymap.set("n", "<leader>/", ":lua MiniPick.builtin.grep_live()<cr>", { silent = true })
vim.keymap.set("n", "<leader>h", ":lua MiniPick.builtin.help()<cr>", { silent = true })
vim.keymap.set("n", "<leader>q", ":lua MiniExtra.pickers.list({ scope = 'quickfix' })<cr>", { silent = true })

return {
    quickfix = {
        setup = function(e)
            local opts = { buffer = e.buf }
            vim.keymap.set("n", "q", ":cclose<cr>", opts)
        end,
    },

    lsp_attach = {
        setup = function(e)
            local opts = { buffer = e.buf, silent = true }
            vim.keymap.set("n", "gd", ":lua MiniExtra.pickers.lsp({scope = 'definition'})<cr>", opts)
            vim.keymap.set("n", "gr", ":lua MiniExtra.pickers.lsp({scope = 'references'})<cr>", opts)
            vim.keymap.set("n", "<leader>s", ":lua MiniExtra.pickers.lsp({scope = 'document_symbol'})<cr>", opts)
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
        end,
    },
}
