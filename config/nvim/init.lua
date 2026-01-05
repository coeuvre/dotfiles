--------------------------------------------------------------------------------
--- Options
--------------------------------------------------------------------------------
local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.expandtab = true
opt.fileformats = "unix,dos"
opt.foldlevel = 99
opt.foldmethod = "expr"
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
opt.swapfile = false
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

if vim.fn.executable("msys2.cmd") == 1 then
  opt.shell = "msys2.cmd -shell fish -full-path"
end

--------------------------------------------------------------------------------
--- Keymaps
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<C-s>", ":w<cr>", { desc = "Save", silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
if vim.fn.has("win32") == 1 then
  -- Also map <BS> on Windows since we cannot distinguish them.
  vim.keymap.set("n", "<BS>", "<C-w>h", { desc = "Go to Left Window", remap = true })
end
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Clear search on escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  vim.snippet.stop()
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Diagnostic
local diagnostic_jump = function(count)
  return function()
    vim.diagnostic.jump({
      count = count,
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({
          bufnr = bufnr,
          scope = "cursor",
          focus = false,
        })
      end,
    })
  end
end
vim.keymap.set("n", "]d", diagnostic_jump(1), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_jump(-1), { desc = "Prev Diagnostic" })

vim.api.nvim_create_user_command("FixAll", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.fixAll" } },
    apply = true,
  })
end, { desc = "LSP Fix All" })

vim.api.nvim_create_user_command("OrganizeImports", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end, { desc = "LSP Organize Imports" })

--------------------------------------------------------------------------------
--- Plugins
--------------------------------------------------------------------------------
if vim.fn.has("nvim-0.12") ~= 1 then
  vim.notify("Requires neovim >= 0.12", vim.log.levels.ERROR)
  return
end

vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update()
end, { desc = "Update Plugins" })

local plugins = {
  -- Colorscheme ---------------------------------------------------------------
  {
    src = "https://github.com/catppuccin/nvim.git",
    name = "catppuccin",
    setup = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Utils ---------------------------------------------------------------------
  "https://github.com/tpope/vim-sleuth",
  {
    src = "https://github.com/nvim-mini/mini.nvim",
    version = "stable",
    setup = function()
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
    src = "https://github.com/stevearc/oil.nvim",
    setup = function()
      require("oil").setup({
        keymaps = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-p>"] = false,
        },
      })
    end,
  },
  {
    src = "https://github.com/williamboman/mason.nvim",
    setup = function()
      require("mason").setup({})
    end,
  },
  {
    src = "https://github.com/MagicDuck/grug-far.nvim",
    setup = function()
      require("grug-far").setup({})
    end,
  },

  -- Formatting ----------------------------------------------------------------
  {
    src = "https://github.com/stevearc/conform.nvim",
    setup = function()
      local web_formatter = { "prettierd", "prettier", stop_after_first = true }
      require("conform").setup({
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },

        formatters_by_ft = {
          c = { "clang-format" },
          cmake = { "cmake_format" },
          cpp = { "clang-format" },
          go = { "gofmt" },
          html = web_formatter,
          javascript = web_formatter,
          javascriptreact = web_formatter,
          lua = { "stylua" },
          python = { "ruff_format" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          typescriptreact = web_formatter,
          typescript = web_formatter,
          zig = { "zigfmt" },
        },
      })

      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Fuzzy finder --------------------------------------------------------------
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    setup = function()
      require("fzf-lua").setup({
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        },
      })

      require("fzf-lua").register_ui_select()

      vim.keymap.set("n", "<C-p>", function()
        require("fzf-lua").files()
      end, { desc = "Find Files" })

      vim.keymap.set("n", "<leader>b", function()
        require("fzf-lua").buffers()
      end, { desc = "Find Buffers" })

      vim.keymap.set("n", "<leader>R", function()
        require("fzf-lua").resume()
      end, { desc = "Resume Last Find" })

      vim.keymap.set("n", "<leader>/", function()
        require("fzf-lua").live_grep()
      end, { desc = "Live Grep" })

      vim.keymap.set("n", "<leader>*", function()
        require("fzf-lua").grep_cword()
      end, { desc = "Grep Cursor Word" })

      vim.keymap.set("n", "gd", function()
        require("fzf-lua").lsp_definitions()
      end, { desc = "LSP Definitions" })

      -- Remap |lsp-defaults| to use fzf-lua
      vim.keymap.set("n", "gra", function()
        require("fzf-lua").lsp_code_actions()
      end, { desc = "LSP Code Actions" })

      vim.keymap.set("n", "gri", function()
        require("fzf-lua").lsp_implementations()
      end, { desc = "LSP Implementations" })

      vim.keymap.set("n", "grr", function()
        require("fzf-lua").lsp_references()
      end, { desc = "LSP References" })

      vim.keymap.set("n", "gO", function()
        require("fzf-lua").lsp_document_symbols()
      end, { desc = "LSP Document Symbols" })
    end,
  },

  -- Auto-completion -----------------------------------------------------------
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
    setup = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "enter",
          ["<C-e>"] = {
            function()
              -- TODO: Cancel inline completion
            end,
            "hide",
            "fallback",
          },
          ["<Tab>"] = {
            function()
              if vim.lsp.inline_completion.get() then
                return true
              end
            end,
            "select_and_accept",
            "fallback",
          },
          ["<S-Tab>"] = { "fallback" },
        },
        completion = {
          trigger = {
            show_in_snippet = false,
          },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },
        signature = { enabled = true },
        sources = {
          default = { "lsp", "buffer", "path" },
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
            end, items)
          end,
        },
      })
    end,
  },

  -- LSP -----------------------------------------------------------------------
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    setup = function()
      local lsp_base_config = {
        capabilities = require("blink.cmp").get_lsp_capabilities({
          textDocument = { completion = { completionItem = { snippetSupport = false } } },
        }),
      }

      local lsps = {
        basedpyright = {},
        clangd = { cmd = { "clangd", "--header-insertion=never" } },
        gopls = {},
        lua_ls = {},
        rust_analyzer = {},
        ts_ls = {},
        zls = {},
      }

      for lsp, config in pairs(lsps) do
        vim.lsp.config(lsp, vim.tbl_extend("force", lsp_base_config, config))
        vim.lsp.enable(lsp)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
            vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
          end
        end,
      })

      vim.api.nvim_create_user_command("ToggleCopilot", function()
        if vim.lsp.is_enabled("copilot") then
          vim.lsp.enable("copilot", false)
          vim.notify("Copilot Disabled", vim.log.levels.INFO)
        else
          vim.lsp.enable("copilot")
          vim.notify("Copilot Enabled", vim.log.levels.INFO)
        end
      end, { desc = "Toggle Copilot" })
    end,
  },

  -- Treesitter ----------------------------------------------------------------
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
    setup = function()
      local parsers = { "c", "cpp", "lua", "vim", "vimdoc", "query", "zig" }

      pcall(require("nvim-treesitter").install, parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          -- folds, provided by Neovim
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Async Tasks ---------------------------------------------------------------
  "https://github.com/skywind3000/asyncrun.vim",
  {
    src = "https://github.com/skywind3000/asynctasks.vim",
    setup = function()
      vim.g.asyncrun_open = 10
      vim.g.asyncrun_auto = "make"

      vim.api.nvim_create_autocmd("User", {
        pattern = "AsyncRunStop",
        callback = function()
          vim.cmd("silent! cnext")
        end,
      })

      vim.keymap.set("n", "<C-q>", function()
        vim.cmd("call asyncrun#quickfix_toggle(10)")
      end, { silent = true, desc = "Quickfix List" })

      vim.keymap.set("n", "<leader>rb", ":AsyncTask build<cr>", { silent = true, desc = "AsyncTask build" })
      vim.keymap.set("n", "<leader>rt", ":AsyncTask test<cr>", { silent = true, desc = "AsyncTask test" })
      vim.keymap.set("n", "<leader>rr", ":AsyncTask run<cr>", { silent = true, desc = "AsyncTask run" })
    end,
  },
}

vim.pack.add(plugins)

for _, plugin in ipairs(plugins) do
  if type(plugin) == "table" then
    local setup = plugin["setup"]
    if type(setup) == "function" then
      setup()
    end
  end
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind == "install" or kind == "update" then
      if name == "nvim-treesitter" then
        vim.cmd("TSUpdate")
      end
    end
  end,
})
