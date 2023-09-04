-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = " "

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      local hop = require('hop')
      hop.setup({ keys = 'etovxqpdygfblzhckisuran' })

      local directions = require('hop.hint').HintDirection
      vim.keymap.set('', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR })
      end, { remap = true })
      vim.keymap.set('', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR })
      end, { remap = true })
      vim.keymap.set('', 'gsj', function()
        hop.hint_lines_skip_whitespace({ direction = directions.AFTER_CURSOR })
      end, { remap = true })
      vim.keymap.set('', 'gsk', function()
        hop.hint_lines_skip_whitespace({ direction = directions.BEFORE_CURSOR })
      end, { remap = true })
      vim.keymap.set('', 'gsw', function()
        hop.hint_words({ direction = directions.AFTER_CURSOR })
      end, { remap = true })
      vim.keymap.set('', 'gsb', function()
        hop.hint_words({ direction = directions.BEFORE_CURSOR })
      end, { remap = true })
    end
  }
})
