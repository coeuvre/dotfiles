return function(use)
  use {
    "phaazon/hop.nvim",

    setup = function()
      local map = require("core.utils").map
      map("", "gsj", [[<Cmd>lua require("hop").hint_lines { direction = require("hop.hint").HintDirection.AFTER_CURSOR }<CR>]])
      map("", "gsk", [[<Cmd>lua require("hop").hint_lines { direction = require("hop.hint").HintDirection.BEFORE_CURSOR }<CR>]])
      map("", "gsw", [[<Cmd>lua require("hop").hint_words { direction = require("hop.hint").HintDirection.AFTER_CURSOR }<CR>]])
      map("", "gsb", [[<Cmd>lua require("hop").hint_words { direction = require("hop.hint").HintDirection.BEFORE_CURSOR }<CR>]])
    end,

    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end
  }
end
