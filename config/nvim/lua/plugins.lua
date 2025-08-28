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
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
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
      "stevearc/oil.nvim",
      opts = {
        keymaps = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-p>"] = false,
        },
      },
      lazy = false,
    },

    {
      "zbirenbaum/copilot.lua",
      config = function()
        vim.g.copilot_loaded = false
        vim.api.nvim_create_user_command("ToggleCopilot", function()
          if not vim.g.copilot_loaded then
            require("copilot").setup({
              panel = { enabled = false },
              suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = false,
                keymap = {
                  accept = false,
                  dismiss = false,
                },
              },
            })
            vim.g.copilot_loaded = true
            return
          end

          if require("copilot.client").is_disabled() then
            vim.cmd("Copilot enable")
          else
            vim.cmd("Copilot disable")
          end
        end, { desc = "Toggle Copilot" })
      end,
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
        keymap = {
          preset = "enter",
          ["<C-e>"] = {
            function()
              if not require("copilot.suggestion").is_visible() then
                return
              end
              require("copilot.suggestion").dismiss()
              return true
            end,
            "hide",
            "fallback",
          },
          ["<Tab>"] = {
            function()
              if not require("copilot.suggestion").is_visible() then
                return
              end

              require("copilot.suggestion").accept()
              return true
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
        local lsps = {
          clangd = {
            cmd = { "clangd", "--header-insertion=never" },
          },
          basedpyright = {},
          lua_ls = {},
          ts_ls = {},
          zls = {},
        }

        local base_config = {
          capabilities = require("blink.cmp").get_lsp_capabilities({
            textDocument = { completion = { completionItem = { snippetSupport = false } } },
          }),
        }
        for lsp, config in pairs(lsps) do
          vim.lsp.config(lsp, vim.tbl_extend("force", base_config, config))
          vim.lsp.enable(lsp)
        end
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

          format_on_save = function()
            -- Disable with a global or buffer-local variable
            if vim.g.disable_format_on_save then
              return
            end

            return { timeout_ms = 1000 }
          end,
        })

        vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
          vim.g.disable_format_on_save = not vim.g.disable_format_on_save
        end, {
          desc = "Toggle FormatOnSave",
        })
      end,
    },

    {
      "tpope/vim-sleuth",
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

        vim.keymap.set("n", "<leader>rb", ":AsyncTask build<cr>", { silent = true, desc = "AsyncTask build" })
        vim.keymap.set("n", "<leader>rt", ":AsyncTask test<cr>", { silent = true, desc = "AsyncTask test" })
        vim.keymap.set("n", "<leader>rr", ":AsyncTask run<cr>", { silent = true, desc = "AsyncTask run" })
      end,
    },

    {
      "MagicDuck/grug-far.nvim",
      opts = {},
    },
  },
})
