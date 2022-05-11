return function(use)
  use {
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp" )
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  }
end
