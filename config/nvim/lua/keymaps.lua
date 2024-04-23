vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-q>", ":ToggleQuickfix<cr>", { silent = true })
vim.keymap.set("n", "<leader>b", ":AsyncTask build<cr>")
vim.keymap.set("n", "<F5>", ":AsyncTask run<cr>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "]q", ":cnext<CR>zz")
vim.keymap.set("n", "[q", ":cprev<CR>zz")

vim.keymap.set("n", "]t", ":tabn<CR>zz")
vim.keymap.set("n", "[t", ":tabp<CR>zz")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- highlight but don't jump
vim.cmd([[nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>]])
vim.cmd([[nnoremap <silent> g* :let @/=expand('<cword>') <bar> set hls <cr>]])

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({})
end)

vim.keymap.set("n", "<C-b>", ":Neotree float reveal toggle<cr>", { silent = true })

return {
    quickfix = {
        setup = function(e)
            local opts = { buffer = e.buf }
            vim.keymap.set("n", "q", ":cclose<cr>", opts)
        end,
    },

    lsp = {
        setup = function()
            vim.keymap.set("n", "K", require("hover").hover)
        end,
    },

    lsp_attach = {
        setup = function(e)
            local fzf = require("fzf-lua")
            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = e.buf }
            vim.keymap.set("n", "gd", function()
                fzf.lsp_definitions({ jump_to_single_result = true })
            end, opts)
            vim.keymap.set("n", "gr", function()
                fzf.lsp_references({
                    ignore_current_line = true,
                    jump_to_single_result = true,
                })
            end, opts)
            vim.keymap.set("n", "<F2>", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, vim.tbl_extend("error", opts, { expr = true }))
            vim.keymap.set("n", "<leader>.", fzf.lsp_code_actions, opts)
        end,
    },

    fzf = {
        setup = function()
            local fzf = require("fzf-lua")
            vim.keymap.set("n", "<leader>r", fzf.resume, {})
            vim.keymap.set("n", "<leader>h", fzf.helptags, {})
            vim.keymap.set("n", "<leader>q", fzf.quickfix, {})
            vim.keymap.set("n", "<leader>s", fzf.lsp_document_symbols, {})
            vim.keymap.set("n", "<C-p>", fzf.files, {})
            vim.keymap.set("n", "<leader><leader>", fzf.buffers, {})
            vim.keymap.set("n", "<leader>/", fzf.live_grep, {})
            vim.keymap.set("n", "<leader>*", fzf.grep_cword, {})
            vim.keymap.set("v", "<leader>*", fzf.grep_visual, {})
        end,
    },
}
