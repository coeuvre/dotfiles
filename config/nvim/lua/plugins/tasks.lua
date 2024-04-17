return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "skywind3000/asyncrun.vim",
    },
    config = function()
        vim.api.nvim_create_user_command("CNextOrClose", function()
            local list = vim.fn.getqflist()
            for _, entry in ipairs(list) do
                if entry.valid == 1 then
                    vim.cmd("cnext")
                    return
                end
            end
            vim.cmd("cclose")
        end, {})
        vim.g.asyncrun_open = 10
        vim.g.asyncrun_auto = "make"
        vim.g.asyncrun_exit = "CNextOrClose"
    end,
}
