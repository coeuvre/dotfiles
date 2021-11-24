---------------------------------------------------------------------------
-- General settings
---------------------------------------------------------------------------
vim.cmd [[
  set expandtab
  set shiftwidth=4
  set tabstop=4
  set hidden
  set relativenumber
  set number
  set termguicolors
  set undofile
  set nospell
  set title
  set ignorecase
  set smartcase
  set wildmode=longest:full,full
  set nowrap
  set list
  set listchars=tab:▸\ ,trail:·
  set mouse=a
  set scrolloff=8
  set sidescrolloff=8
  set nojoinspaces
  set splitright
  set clipboard=unnamedplus
  set confirm
  set exrc
  set backup
  set updatetime=300 " Reduce time for highlighting other references
  set redrawtime=10000 " Allow more time for loading syntax on large files
]]

vim.opt.backupdir = vim.fn.stdpath("data").."/backup//"

---------------------------------------------------------------------------
-- Plugins
---------------------------------------------------------------------------
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup {
  function(use)
    use 'wbthomason/packer.nvim'
    use "nvim-lua/plenary.nvim"

    -- Basic
    use "tpope/vim-unimpaired"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-sleuth"
    use "andymass/vim-matchup"
    use "pbrisbin/vim-mkdir"
    use { "luukvbaal/stabilize.nvim", config = function() require("stabilize").setup() end }
    use { "numToStr/Comment.nvim", config = function() require("Comment").setup() end }
    use {
      "phaazon/hop.nvim",
      branch = "v1",
      config = function()
        require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }
      end,
    }
    use "christoomey/vim-tmux-navigator"
    use "RRethy/vim-illuminate"
    use "nelstrom/vim-visual-star-search"

    -- UI
    use { "kyazdani42/nvim-web-devicons", config = function() require("nvim-web-devicons").setup { default = true } end }
    use { "joshdick/onedark.vim", config = function() vim.cmd[[colorscheme onedark]] end }
    use {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup {
          options = {
            component_separators = "",
            section_separators = "",
          },
          extensions = { "fugitive" }
        }
      end,
    }
    use "rcarriga/nvim-notify"
    use "mbbill/undotree"
    use { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end }

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      config = function()
        local actions = require("telescope.actions")
        local utils = require("telescope.utils")
        require("telescope").setup {
          defaults = {
            preview = {
              timeout = 500,
              msg_bg_fillchar = "",
            },
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden",
            },
            prompt_prefix = "❯ ",
            selection_caret = "❯ ",
            sorting_strategy = "ascending",
            color_devicons = true,
            layout_config = {
              prompt_position = "bottom",
              horizontal = {
                width_padding = 0.04,
                height_padding = 0.1,
                preview_width = 0.6,
              },
              vertical = {
                width_padding = 0.05,
                height_padding = 1,
                preview_height = 0.5,
              },
            },
            dynamic_preview_title = true,
            winblend = 3,
          },
        }
      end,
    }

    -- nvim-treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require'nvim-treesitter.configs'.setup {
          matchup = {
            enable = true
          },
        }
      end,
    }
    use "nvim-treesitter/nvim-treesitter-refactor"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "nvim-treesitter/playground"
    use { "lewis6991/spellsitter.nvim", config = function() require("spellsitter").setup() end }

    -- nvim-lsp
    -- TODO
    use "nvim-lua/lsp-status.nvim"
    use "onsails/lspkind-nvim"

    -- nvim-cmp
    -- TODO
    use { "windwp/nvim-autopairs", config = function() require('nvim-autopairs').setup() end }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
  },
}

---------------------------------------------------------------------------
-- Mappings
---------------------------------------------------------------------------
local key_map = vim.api.nvim_set_keymap

vim.g.mapleader = " "


vim.cmd [[
" Quicker switching between windows
nmap <silent> <C-h> <C-w>h
nmap <silent> <C-j> <C-w>j
nmap <silent> <C-k> <C-w>k
nmap <silent> <C-l> <C-w>l

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Make Y behave like the other capitals
nnoremap Y y$

" Keep it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

cmap w!! %!sudo tee > /dev/null %
]]


-- browse file
key_map(
  "n",
  "<leader>ff",
  [[<cmd>lua require"telescope.builtin".file_browser({results_title="Browse Files"})<cr>]],
  { noremap = true, silent = true }
)

-- find files
key_map(
  "n",
  "<leader><leader>",
  [[<cmd>lua require"telescope.builtin".find_files({results_title="Find Files"})<cr>]],
  { noremap = true, silent = true }
)

-- recent files
key_map(
  "n",
  "<leader>fr",
  [[<cmd>lua require"telescope.builtin".oldfiles({results_title="Recent Files"})<cr>]],
  { noremap = true, silent = true }
)

-- grep under cursor
key_map(
  "n",
  "<leader>*",
  [[<cmd>lua require"telescope.builtin".grep_string()<cr>]],
  { noremap = true, silent = true }
)

-- list buffers
key_map(
  "n",
  "<leader>bb",
  [[<cmd>lua require"telescope.builtin".buffers({results_title="Buffers"})<cr>]],
  { noremap = true, silent = true }
)

-- easy motion
key_map("n", "f", [[<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true })<cr>]], {})
key_map("n", "F", [[<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>]], {})
key_map("o", "f", [[<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>]], {})
key_map("o", "F", [[<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>]], {})
key_map("", "t", [[<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.AFTER_CURSOR, current_line_only = true })<cr>]], {})
key_map("", "T", [[<cmd>lua require"hop".hint_char1({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>]], {})
key_map("", "gsj", [[<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.AFTER_CURSOR })<cr>]], {})
key_map("", "gsk", [[<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR })<cr>]], {})
