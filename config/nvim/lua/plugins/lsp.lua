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

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local on_attach = function(client, bufnr)
        require("illuminate").on_attach(client)

        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
              vim.lsp.buf.formatting_sync()
            end,
          })
        end
      end

      lspconfig.sumneko_lua.setup({
        capabilities = capabilities,
        on_attach = on_attach,

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

      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  }
end
