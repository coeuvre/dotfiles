return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local opts = require("telescope.themes").get_ivy({
            layout_config = {
                height = 12,
            },
            previewer = false,
        })
        telescope.setup({
            pickers = {
                help_tags = opts,
                quickfix = opts,
                find_files = opts,
                buffers = opts,
                live_grep = opts,
                grep_string = opts,
            },
        })

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>h", builtin.help_tags, {})
        vim.keymap.set("n", "<leader>q", builtin.quickfix, {})
        vim.keymap.set("n", "<C-p>", builtin.find_files, {})
        vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
        vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
        vim.keymap.set({ "n", "v" }, "<leader>*", builtin.grep_string, {})
    end,
}
