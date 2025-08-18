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
      config = function()
        require("fzf-lua").setup({
          keymap = {
            fzf = {
              ["ctrl-q"] = "select-all+accept",
            },
          },
        })

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

        vim.keymap.set("n", "grr", function()
          require("fzf-lua").lsp_references()
        end, { desc = "LSP References" })

        vim.keymap.set("n", "gri", function()
          require("fzf-lua").lsp_implementations()
        end, { desc = "LSP Implementations" })

        vim.keymap.set("n", "gO", function()
          require("fzf-lua").lsp_document_symbols()
        end, { desc = "LSP Document Symbols" })

        vim.keymap.set("n", "gra", function()
          require("fzf-lua").lsp_code_actions()
        end, { desc = "LSP Code Actions" })
      end,
    },

    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup({})

        vim.keymap.set({ "n", "v" }, "<C-b>", ":NvimTreeFindFileToggle<cr>", { silent = true, desc = "File Explorer" })
      end,
    },

    {
      "github/copilot.vim",
      config = function()
        vim.cmd("Copilot disable")

        vim.keymap.set("n", "<F12>", function()
          if vim.g.copilot_enabled == 1 then
            vim.cmd("Copilot disable")
            vim.cmd("Copilot status")
          else
            vim.cmd("Copilot enable")
            vim.cmd("Copilot status")
          end
        end, { desc = "ToggleCopilot" })
      end,
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
        keymap = { preset = "super-tab" },
        completion = {
          trigger = {
            show_in_snippet = false,
          },
        },
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

        vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.keymap.set({ "n", "v" }, "<leader>f", function()
          require("conform").format()
        end, { desc = "Format" })

        vim.keymap.set({ "n", "v" }, "<leader>F", function()
          -- TODO: Use task when it's available in neovim 0.12+ to chain the tasks.
          -- Currently, they all execute concurrently which might result in the buffer
          -- being saved for multiple times.
          local buf = vim.api.nvim_buf_get_name(0)
          if string.match(buf, "%.zig$") then
            vim.lsp.buf.code_action({
              context = { only = { "source.fixAll" } },
              apply = true,
            })
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" } },
              apply = true,
            })
          end
        end, { desc = "Fix" })
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

        vim.api.nvim_create_autocmd("User", {
          pattern = "AsyncRunStop",
          callback = function()
            -- Close quickfix if no errors
            -- if vim.g.asyncrun_code == 0 then
            --   vim.cmd("call asyncrun#quickfix_toggle(10)")
            --   return
            -- end
            vim.cmd("silent! cnext")
          end,
        })

        vim.keymap.set("n", "<C-q>", function()
          vim.cmd("call asyncrun#quickfix_toggle(10)")
        end, { silent = true, desc = "Quickfix List" })

        vim.keymap.set("n", "<leader>rb", ":wa <bar> AsyncTask build<cr>", { silent = true, desc = "AsyncTask build" })
        vim.keymap.set("n", "<leader>rt", ":wa <bar> AsyncTask test<cr>", { silent = true, desc = "AsyncTask test" })
        vim.keymap.set("n", "<leader>rr", ":AsyncTask run<cr>", { silent = true, desc = "AsyncTask run" })
      end,
    },

    {
      "MagicDuck/grug-far.nvim",
      opts = {},
    },
  },
})
