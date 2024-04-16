local keymaps = require("keymaps")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(e)
        keymaps.quickfix.setup(e)
    end,
})

-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--     pattern = "[^l]*",
--     command = "cnext",
--     nested = true,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
        keymaps.lsp.setup(e)
    end,
})
