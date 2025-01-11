-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-p>", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

vim.keymap.set("n", "<F9>", ":wa <bar> AsyncTask build<cr>", { silent = true, desc = "AsyncTask build"})
vim.keymap.set("n", "<F5>", ":AsyncTask run<cr>", { silent = true , desc = "AsyncTask run"})
vim.keymap.set("n", "<C-q>", ":ToggleQuickfix<cr>", { silent = true, desc = "ToggleQuickfix" })
vim.keymap.set("n", "]q", ":cnext<CR>zz", { silent = true, desc = "Next Quickfix" })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { silent = true, desc = "Prev Quickfix" })

vim.api.nvim_create_user_command("ToggleQuickfix", function()
  vim.cmd("call asyncrun#quickfix_toggle(10)")
end, {})
