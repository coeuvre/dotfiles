return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "skywind3000/asyncrun.vim",
    },
    config = function()
        vim.g.asyncrun_open = 6
        vim.g.asyncrun_bell = 1
    end,
}
