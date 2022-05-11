local g = vim.g
local opt = vim.opt

g.mapleader = " "


-- use filetype.lua instead of filetype.vim
-- TODO(coeuvre): Check if Neovim 0.8 makes it default
g.did_load_filetypes = 0
g.do_filetype_lua = 1

opt.confirm = true
opt.laststatus = 3 -- global statusline
opt.title = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.cursorline = true
opt.completeopt = "menuone,noselect"
opt.wrap = false

-- indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- numbers
opt.number = true
opt.numberwidth = 2

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true

opt.termguicolors = true

opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

opt.shadafile = vim.fn.stdpath("data").."/shada/main.shada"

