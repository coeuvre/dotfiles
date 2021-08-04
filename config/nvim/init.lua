-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

local use = require('packer').use
require('packer').startup(function()
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Git commands in nvim
  use 'tpope/vim-fugitive'

  -- Magit clone in nvim
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

  -- "gc" to comment visual regions/lines
  use 'tpope/vim-commentary'

  -- Auto detect indentation
  use 'tpope/vim-sleuth'

  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }

  -- Theme inspired by Atom
  use 'joshdick/onedark.vim'

  -- Fancier statusline
  use 'itchyny/lightline.vim'

  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'

  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'

  -- Autocompletion plugin
  use 'hrsh7th/nvim-compe'

  -- Snippets plugin
  use 'L3MON4D3/LuaSnip'

  -- Display scrollbar
  use 'dstein64/nvim-scrollview'

  -- Easy motion
  use { 'phaazon/hop.nvim' }

  -- Highlight word under cursor
  use { 'yamatsum/nvim-cursorline' }

  -- Change current working directory to 'project root'
  use 'airblade/vim-rooter'

  -- async tasks
  use { 'skywind3000/asynctasks.vim' }
  use { 'skywind3000/asyncrun.vim' }

  use { 'tpope/vim-unimpaired' }

  use { 'rust-lang/rust.vim' }
end)

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------

-- Incremental live completion
vim.opt.inccommand = 'nosplit'

-- Set highlight on search
vim.opt.hlsearch = false

-- Make relativeline numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Display cursor line
vim.opt.cursorline = true

-- Use system clipboard by default
vim.opt.clipboard = 'unnamedplus'

-- Do not save when switching buffers
vim.opt.hidden = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.cmd [[set undofile]]

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'

-- Set colorscheme (order is important here)
vim.opt.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme onedark]]

-- Set statusbar
vim.g.lightline = {
  colorscheme = 'onedark',
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}

-- Set foldmethod
vim.wo.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

require('gitsigns').setup {}

require("indent_blankline").setup {
    filetype_exclude = { 'help', 'packer' },
    buftype_exclude = { 'terminal', 'nofile' },
}

-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })


-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })


-- No need for ex mode
vim.api.nvim_set_keymap('n', 'Q', '<Nop>', { noremap = true, silent = true })

-- Easy switch between windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })

-- Exit terminal insert mode with <Esc>
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })


-------------------------------------------------------------------------------
-- Async tasks
-------------------------------------------------------------------------------

vim.g.asyncrun_open = 8

-- Shortcuts for build and run
vim.api.nvim_set_keymap('n', '<F5>', ":AsyncTask project-run<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F7>', ":AsyncTask project-build<CR>", { noremap = true, silent = true })

_G.close_quickfix_if_no_error = function()
  local error_count = vim.api.nvim_eval [[ len(filter(getqflist(), { k,v -> v.bufnr != 0 })) ]]
  if error_count == 0 then vim.cmd 'cclose' end
end

vim.cmd [[
  autocmd User AsyncRunStop silent! lua close_quickfix_if_no_error()
]]

-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------

require('telescope').setup()

-- files
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f*', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

-- buffers
vim.api.nvim_set_keymap('n', '<leader>bb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bg', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })


-------------------------------------------------------------------------------
-- Hop
-------------------------------------------------------------------------------
require('hop').setup {
  keys = 'etovxqpdygfblzhckisuran',
}

vim.api.nvim_set_keymap('n', 'gsk', [[<cmd>lua require('hop').hint_lines { direction = require('hop.hint').HintDirection.BEFORE_CURSOR }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gsj', [[<cmd>lua require('hop').hint_lines { direction = require('hop.hint').HintDirection.AFTER_CURSOR }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gsb', [[<cmd>lua require('hop').hint_words { direction = require('hop.hint').HintDirection.BEFORE_CURSOR }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gsw', [[<cmd>lua require('hop').hint_words { direction = require('hop.hint').HintDirection.AFTER_CURSOR }<CR>]], { noremap = true, silent = true })

-------------------------------------------------------------------------------
-- Neogit
-------------------------------------------------------------------------------
require('neogit').setup {}

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
local nvim_lsp = require('lspconfig')
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>pe', [[<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<CR>]], opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  vim.cmd [[ autocmd BufWritePost * Format ]]
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable the following language servers
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Example custom server
local sumneko_root_path = vim.fn.getenv("HOME").."/.local/bin/sumneko_lua" -- Change to your sumneko root installation
local sumneko_binary = sumneko_root_path .. '/bin/linux/lua-language-server'

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-------------------------------------------------------------------------------
-- Treesitter
-------------------------------------------------------------------------------

-- Parsers must be installed manually via :TSInstall

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'rust' },
  highlight = { enable = true },
  indent = { enable = true },
}

-------------------------------------------------------------------------------
-- Auto completion
-------------------------------------------------------------------------------

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- Compe setup
require('compe').setup {
  preselect = 'always',
  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true,
    luasnip = true,

    calc = false,
    vsnip = false,
    ultisnips = false,
  },
}

-- Utility functions for compe and luasnip
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local luasnip = require 'luasnip'

_G.tab_complete = function()
  if luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#confirm']('')
  end
end

_G.s_tab_complete = function()
  if luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
end

_G.cr_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-e><cr>'
  else
    return t '<cr>'
  end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})

vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.cr_complete()', { expr = true })
