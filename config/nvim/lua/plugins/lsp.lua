return {
  {
    "neovim/nvim-lspconfig",

    opts = {
      inlay_hints = {
        enabled = false,
      },

      diagnostics = {
        virtual_text = false,
        virtual_lines = true,
      },

      capabilities = {
        -- disable snippet
        textDocument = { completion = { completionItem = { snippetSupport = false } } },
      },

      servers = {
        zls = {
          mason = false,
          settings = {
            -- Semantic tokens causes highlight flicker when saving the file.
            semantic_tokens = "none",
          },
        },
        ols = {},
      },
    },
  },
}
