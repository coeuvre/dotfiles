return {
  {
    "tpope/vim-sleuth"
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      debounce_delay = 300,
      condition = function()
        -- don't save for special-buffers
        if vim.bo.buftype ~= "" then
          return false
        end

        return vim.bo.modifiable
      end,
    },
  },
  {
    "skywind3000/asynctasks.vim",
    dependencies = {
      "skywind3000/asyncrun.vim",
    },
  },
}
