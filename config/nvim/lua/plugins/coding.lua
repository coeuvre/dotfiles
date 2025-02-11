return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      fuzzy = {
        max_typos = function()
          return 0
        end,
      },
      sources = {
        default = { "lsp", "path", "buffer" },

        -- disable snippets
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
          end, items)
        end,
      },
      signature = { enabled = true },
    },
  },

  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
}
