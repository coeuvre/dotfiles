return {
    "stevearc/overseer.nvim",
    config = function()
        local overseer = require("overseer")
        overseer.setup({})

        overseer.register_template({
            name = "zig build",
            builder = function()
                return {
                    cmd = { "zig" },
                    args = { "build" },
                    name = "zig build",
                    components = {
                        {
                            "on_output_quickfix",
                            open_on_match = true,
                            close = true,
                            set_diagnostics = true,
                        },
                        "on_result_diagnostics",
                        "default",
                    },
                }
            end,
            tags = { overseer.TAG.BUILD },
        })

        vim.api.nvim_create_user_command("OverseerRestartLast", function()
            local tasks = overseer.list_tasks({ recent_first = true })
            if vim.tbl_isempty(tasks) then
                vim.cmd("OverseerRun")
            else
                overseer.run_action(tasks[1], "restart")
            end
        end, {})

        vim.api.nvim_create_user_command("OverseerEditLast", function()
            local tasks = overseer.list_tasks({ recent_first = true })
            if vim.tbl_isempty(tasks) then
                vim.notify("No tasks found", vim.log.levels.WARN)
            else
                overseer.run_action(tasks[1], "edit")
            end
        end, {})
    end,
}
