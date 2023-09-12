-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.termguicolors = true
vim.o.wrap = false
vim.o.laststatus = 3
vim.o.number = true
vim.o.cursorline = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = { enabled = false },
        char = { keys = { "f", "F", "t", "T" } }
      }
    },
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
    },
  }
}

if not vim.g.vscode then
  plugins = {
    unpack(plugins),

    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        vim.cmd("colorscheme catppuccin")
      end
    },
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup()
        vim.keymap.set("n", "<C-\\>", ":NvimTreeToggle<CR>")
      end
    },
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup({
          options = {
            component_separators = '',
            section_separators = '',
          }
        })
      end,
    },

    "christoomey/vim-tmux-navigator",
  }
end

require("lazy").setup(plugins)
