-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-p>", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

vim.keymap.set("n", "<leader>rb", ":wa <bar> AsyncTask build<cr>", { silent = true, desc = "AsyncTask build" })
vim.keymap.set("n", "<leader>rr", ":AsyncTask run<cr>", { silent = true, desc = "AsyncTask run" })
vim.keymap.set("n", "<C-q>", ":ToggleQuickfix<cr>", { silent = true, desc = "ToggleQuickfix" })
vim.keymap.set("n", "]q", ":cnext<CR>zz", { silent = true, desc = "Next Quickfix" })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { silent = true, desc = "Prev Quickfix" })

vim.api.nvim_create_user_command("ToggleQuickfix", function()
  vim.cmd("call asyncrun#quickfix_toggle(10)")
end, {})

-- Remove some LazyVim's default keymaps

-- Move Lines
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")

-- buffers
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

if vim.g.neovide then
  vim.keymap.set(
    { "n", "v" },
    "<C-=>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true }
  )
  vim.keymap.set(
    { "n", "v" },
    "<C-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true }
  )
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })
end
