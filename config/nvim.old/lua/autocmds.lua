local keymaps = require("keymaps")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(e)
        keymaps.quickfix.setup(e)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "AsyncRunStop",
    callback = function()
        if vim.g.asyncrun_code == 0 then
            vim.cmd("ToggleQuickfix")
            return
        end
        vim.cmd("silent! cnext")
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
        keymaps.lsp_attach.setup(e)
    end,
})
