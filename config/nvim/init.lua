-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Options ---------------------------------------------------------------------
do
  local opt = vim.opt
  opt.autowrite = true
  opt.clipboard = "unnamedplus"
  opt.confirm = true
  opt.expandtab = true
  opt.fileformats = "unix,dos"
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  opt.foldlevel = 99
  opt.foldmethod = "expr"
  opt.formatexpr = "v:lua.require'conform'.formatexpr()"
  opt.grepformat = "%f:%l:%c:%m"
  opt.grepprg = "rg --vimgrep"
  opt.guifont = "JetBrainsMonoNL NFP"
  opt.ignorecase = true
  opt.jumpoptions = "view"
  opt.laststatus = 3 -- global statusline
  opt.list = true
  opt.mouse = "a"
  opt.number = true
  opt.pumblend = 10 -- Popup blend
  opt.pumheight = 10 -- Maximum number of entries in a popup
  opt.relativenumber = true
  opt.scrolloff = 4
  opt.shiftround = true
  opt.shiftwidth = 2
  opt.showmode = false
  opt.sidescrolloff = 8
  opt.signcolumn = "yes"
  opt.smartcase = true
  opt.smartindent = true
  opt.splitbelow = true
  opt.splitkeep = "screen"
  opt.splitright = true
  --opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
  opt.tabstop = 2
  opt.termguicolors = true
  opt.undofile = true
  opt.undolevels = 100000
  opt.updatetime = 200
  opt.virtualedit = "block"
  opt.winminwidth = 5
  opt.wrap = false

  vim.g.zig_fmt_parse_errors = 0
  vim.g.zig_fmt_autosave = 0
end

-- Keymaps ---------------------------------------------------------------------
do
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  local map = vim.keymap.set

  -- Better up/down
  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
  map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

  -- Move to window using the <ctrl> hjkl keys
  map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
  map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
  map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
  map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

  -- Clear search on escape
  map({ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
  end, { expr = true, desc = "Escape and Clear hlsearch" })

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

  -- Better indenting
  map("v", "<", "<gv")
  map("v", ">", ">gv")

  -- Quickfix list
  vim.api.nvim_create_user_command("ToggleQuickfix", function()
    vim.cmd("call asyncrun#quickfix_toggle(10)")
  end, {})
  map("n", "<C-q>", ":ToggleQuickfix<CR>", { silent = true, desc = "Quickfix List" })
  map("n", "]q", ":cnext<CR>zz", { silent = true, desc = "Next Quickfix" })
  map("n", "[q", ":cprev<CR>zz", { silent = true, desc = "Prev Quickfix" })

  -- Formatting
  map({ "n", "v" }, "<leader>cf", function()
    require("conform").format()
  end, { desc = "Format" })

  -- Diagnostic
  local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go({ severity = severity })
    end
  end
  map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
  map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })

  -- AsyncTasks
  map("n", "<leader>rb", ":wa <bar> AsyncTask build<cr>", { silent = true, desc = "AsyncTask build" })
  map("n", "<leader>rr", ":AsyncTask run<cr>", { silent = true, desc = "AsyncTask run" })
end

-- Autocmds --------------------------------------------------------------------
vim.api.nvim_create_autocmd("User", {
  pattern = "AsyncRunStop",
  callback = function()
    if vim.g.asyncrun_code == 0 then
      vim.cmd("ToggleQuickfix")
      return
    end
    vim.api.nvim_feedkeys("]q", "m", true)
  end,
})

-- Plugins ---------------------------------------------------------------------
require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd("colorscheme catppuccin-mocha")
      end,
    },

    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      },
    },

    {
      "folke/snacks.nvim",
      ---@type snacks.Config
      opts = {
        bigfile = {},
        explorer = {},
      },
    },

    -- Completion
    {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
        keymap = { preset = "super-tab" },

        fuzzy = {
          max_typos = function()
            return 0
          end,
        },

        signature = { enabled = true },
      },
    },

    -- LSP
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "javascript", "html", "zig" },
          sync_install = false,
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
        })
      end,
    },

    {
      "neovim/nvim-lspconfig",
      config = function()
        vim.lsp.enable({ "lua_ls", "clangd", "zls" })
      end,
    },

    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },

    -- Formatting
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
          },
        })
      end,
    },

    {
      "tpope/vim-sleuth",
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
      config = function()
        vim.g.asyncrun_open = 10
        vim.g.asyncrun_auto = "make"
      end,
    },
  },
})
