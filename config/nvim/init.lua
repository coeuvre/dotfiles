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

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
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
    vim.snippet.stop()
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
  map("n", "<C-q>", function()
    vim.cmd("call asyncrun#quickfix_toggle(10)")
  end, { silent = true, desc = "Quickfix List" })

  -- Formatting
  map({ "n", "v" }, "<leader>f", function()
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

  -- Pickers
  map("n", "<C-p>", function()
    require("fzf-lua").files()
  end, { desc = "Find Files" })

  map("n", "<leader>R", function()
    require("fzf-lua").resume()
  end, { desc = "Resume Last Find" })

  map("n", "<leader>b", function()
    require("fzf-lua").buffers()
  end, { desc = "Find Buffers" })

  map("n", "<leader>/", function()
    require("fzf-lua").live_grep()
  end, { desc = "Live Grep" })

  map("n", "<leader>*", function()
    require("fzf-lua").grep_cword()
  end, { desc = "Grep Cursor Word" })

  map("n", "gd", function()
    require("fzf-lua").lsp_definitions()
  end, { desc = "LSP Definitions" })

  map("n", "grr", function()
    require("fzf-lua").lsp_references()
  end, { desc = "LSP References" })

  map("n", "gri", function()
    require("fzf-lua").lsp_implementations()
  end, { desc = "LSP Implementations" })

  map("n", "gO", function()
    require("fzf-lua").lsp_document_symbols()
  end, { desc = "LSP Document Symbols" })

  map("n", "gra", function()
    require("fzf-lua").lsp_code_actions()
  end, { desc = "LSP Code Actions" })

  -- File Explorer
  map({ "n", "v" }, "<leader>e", ":NvimTreeOpen<cr>", { silent = true, desc = "File Explorer" })

  -- AsyncTasks
  map("n", "<leader>rb", ":wa <bar> AsyncTask build<cr>", { silent = true, desc = "AsyncTask build" })
  map("n", "<leader>rr", ":AsyncTask run<cr>", { silent = true, desc = "AsyncTask run" })
end

-- Autocmds --------------------------------------------------------------------
vim.api.nvim_create_autocmd("User", {
  pattern = "AsyncRunStop",
  callback = function()
    if vim.g.asyncrun_code == 0 then
      vim.cmd("call asyncrun#quickfix_toggle(10)")
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
      "echasnovski/mini.nvim",
      version = false,
      config = function()
        require("mini.ai").setup()
        require("mini.comment").setup()
        require("mini.diff").setup()
        require("mini.splitjoin").setup()
        require("mini.statusline").setup({
          use_icons = false,
        })
        require("mini.trailspace").setup()
      end,
    },

    {
      "ibhagwan/fzf-lua",
      opts = {
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        },
      },
    },

    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
      },
    },

    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup({})
      end,
    },

    {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
        keymap = { preset = "super-tab" },
        signature = { enabled = true },
      },
    },

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
        vim.lsp.config("clangd", {
          cmd = { "clangd", "--header-insertion=never" },
        })
        vim.lsp.enable({
          "basedpyright",
          "clangd",
          "lua_ls",
          "ts_ls",
          "zls",
        })
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
        local web_formatter = { "prettierd", "prettier", stop_after_first = true }
        require("conform").setup({
          formatters_by_ft = {
            c = { "clang-format" },
            cmake = { "cmake_format" },
            cpp = { "clang-format" },
            html = web_formatter,
            javascript = web_formatter,
            lua = { "stylua" },
            python = { "ruff_format" },
            sh = { "shfmt" },
            typescript = web_formatter,
            typescriptreact = web_formatter,
            zig = { "zigfmt" },
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

    {
      "MagicDuck/grug-far.nvim",
      opts = {},
    },
  },
})
