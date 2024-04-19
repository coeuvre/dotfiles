return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "skywind3000/asyncrun.vim",
    },
    config = function()
        vim.api.nvim_create_user_command("ToggleQuickfix", function()
            vim.cmd("call asyncrun#quickfix_toggle(10)")
        end, {})
        vim.g.asyncrun_open = 10
        vim.g.asyncrun_auto = "make"
    end,
}
