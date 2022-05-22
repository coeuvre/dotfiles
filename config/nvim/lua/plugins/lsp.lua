return function(use)
  use "williamboman/nvim-lsp-installer"

  use {
    "neovim/nvim-lspconfig",
    after = "nvim-lsp-installer",

    setup = function()
      local map = require("core.utils").map
      map("n", "K", function() vim.lsp.buf.hover() end)
      map("n", "<leader>ca", function() vim.lsp.buf.code_action() end)
      map("n", "<leader>cr", function() vim.lsp.buf.rename() end)
      map("n", "<leader>cf", function() vim.lsp.buf.formatting() end)
    end,

    config = function()
      require("nvim-lsp-installer").setup({})
      local lspconfig = require("lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

      lspconfig.sumneko_lua.setup({
        capabilities = capabilities,

        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.clangd.setup({})
    end,
  }
end
