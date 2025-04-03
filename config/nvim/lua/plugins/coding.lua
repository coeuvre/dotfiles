return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        ghost_text = {
          enabled = false,
        },
      },

      fuzzy = {
        implementation = "lua",
      },

      signature = { enabled = true },

      sources = {
        default = { "lsp", "buffer", "path" },

        -- disable snippets
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
          end, items)
        end,
      },
    },
  },
}
