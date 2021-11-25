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

local backupdir = vim.fn.stdpath("data").."/backup//"
vim.opt.backupdir = backupdir
if vim.fn.empty(vim.fn.glob(backupdir)) > 0 then
  vim.cmd('call mkdir(&backupdir)')
end

---------------------------------------------------------------------------
-- Plugins
---------------------------------------------------------------------------
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup {
  function(use)
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim"

    -- Basic
    use { "folke/which-key.nvim", config = function() require("which-key").setup() end }
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
        require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
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
        require("nvim-treesitter.configs").setup {
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
    use "neovim/nvim-lspconfig"
    use "nvim-lua/lsp-status.nvim"
    use "onsails/lspkind-nvim"

    -- nvim-cmp
    use {
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require("cmp")
        cmp.setup {
          completion = {
            completeopt = "menu,menuone,noinsert",
          },
          snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = {
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
              end

              if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                end
                cmp.confirm()
              elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
              else
                fallback()
              end
            end, { "i", "s", "c" }),
          },
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "vsnip" },
          }, {
            { name = "buffer" },
          }),
          experimental = {
            ghost_text = true,
          },
        }

        -- Use buffer source for / (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
          sources = {
            { name = "buffer" }
          }
        })

        -- Use cmdline & path source for : (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
          sources = cmp.config.sources({
            { name = "path" }
          }, {
            { name = "cmdline" }
          })
        })

        -- Setup lspconfig.
        local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
        local lspconfig = require("lspconfig")
        local servers = { "clangd", "rust_analyzer", "pyright", "tsserver", "gopls", "zls" }
        for _, server in ipairs(servers) do
          lspconfig[server].setup {
            on_attach = function(client)
              local key_map = vim.api.nvim_buf_set_keymap

              local opts = { noremap = true, silent = true }
              key_map(bufnr, "n", "gd", [[<cmd>lua require("telescope.builtin").lsp_definitions()<CR>]], opts)
              key_map(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
              key_map(bufnr, "n", "gi", [[<cmd>lua require("telescope.builtin").lsp_implementations()<CR>]], opts)
              key_map(bufnr, "n", "gr", [[<cmd>lua require("telescope.builtin").lsp_references()<CR>]], opts)
              key_map(bufnr, "n", "<space>ca", [[<cmd>lua require("telescope.builtin").lso_code_actions()<CR>]], opts)

              key_map(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
              key_map(bufnr, "i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

              key_map(bufnr, "n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
              key_map(bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
              key_map(bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)

              key_map(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
              key_map(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
              key_map(bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
              key_map(bufnr, "n", "<leader>wd", [[<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<CR>]], opts)

              require("illuminate").on_attach(client)
            end,
            capabilities = capabilities,
          }
        end
      end,
    }
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"
    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup()

        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({  map_char = { tex = "" } }))
      end,
    }

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
  [[<cmd>lua require"telescope.builtin".file_browser({results_title="Browse Files"})<CR>]],
  { noremap = true, silent = true }
)

-- find files
key_map(
  "n",
  "<leader><leader>",
  [[<cmd>lua require"telescope.builtin".find_files({results_title="Find Files"})<CR>]],
  { noremap = true, silent = true }
)

-- recent files
key_map(
  "n",
  "<leader>fr",
  [[<cmd>lua require"telescope.builtin".oldfiles({results_title="Recent Files"})<CR>]],
  { noremap = true, silent = true }
)

-- grep under cursor
key_map(
  "n",
  "<leader>*",
  [[<cmd>lua require"telescope.builtin".grep_string()<CR>]],
  { noremap = true, silent = true }
)

-- list buffers
key_map(
  "n",
  "<leader>bb",
  [[<cmd>lua require"telescope.builtin".buffers({results_title="Buffers"})<CR>]],
  { noremap = true, silent = true }
)

-- easy motion
key_map("", "gsj", [[<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.AFTER_CURSOR })<CR>]], {})
key_map("", "gsk", [[<cmd>lua require"hop".hint_lines({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR })<CR>]], {})
key_map("", "gsw", [[<cmd>lua require"hop".hint_words({ direction = require"hop.hint".HintDirection.AFTER_CURSOR })<CR>]], {})
key_map("", "gsb", [[<cmd>lua require"hop".hint_words({ direction = require"hop.hint".HintDirection.BEFORE_CURSOR })<CR>]], {})
