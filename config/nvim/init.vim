""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Environments
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

silent function! WINDOWS()
    return  has('win32') || has('win64')
endfunction

if WINDOWS()
    let $PLUGDIR = '~\AppData\Local\nvim\plugged'
    let $MYCACHEDIR = '~\AppData\Local\nvim\cache'
else
    let $PLUGDIR = '~/.local/share/nvim/plugged'
    let $MYCACHEDIR = '~/.cache/nvim'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin($PLUGDIR)

" VIM Enhancements
Plug 'tpope/vim-sensible'
Plug 'machakann/vim-highlightedyank' " {
    let g:highlightedyank_highlight_duration = 100
" }
Plug 'haya14busa/incsearch.vim' " {
    let g:incsearch#auto_nohlsearch = 1
" }
Plug 'ntpeters/vim-better-whitespace' " {
    let g:better_whitespace_enabled=1
    let g:strip_whitespace_on_save=1
" }

" Fuzzy Finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " {
    let g:fzf_command_prefix = 'FZF'
" }

" Completion
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2' " {
    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()

    " IMPORTANTE: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect

    " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
    " found' messages
    set shortmess+=c

    " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
    inoremap <c-c> <ESC>

    " When the <Enter> key is pressed while the popup menu is visible, it only
    " hides the menu. Use this mapping to close the menu and also start a new
    " line.
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"<Paste>
" }

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'

" GUI
Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'

call plug#end()

colorscheme base16-tomorrow-night

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set noshowmode                      " Use status line plugins to display mode
set cursorline
set hidden                          " Allow buffer switching without saving
set cursorline                      " Highlight current line
set nowrap                          " Do not wrap long lines
set shiftwidth=0                    " use 'ts' value
set expandtab                       " Tabs are spaces, not tabs
set tabstop=4                       " An indentation every four columns
set softtabstop=4                   " Let backspace delete indent
set cindent                         " do C program indenting
set cinoptions=l1,(0,W1s,m1         " set C indent options
set encoding=utf-8
set fileencoding=utf-8
set backup                          " Backups are nice ...
set undofile                        " So is persistent undo ...
set undolevels=1000                 " Maximum number of changes that can be undone
set undoreload=10000                " Maximum number lines to save for undo on a buffer reload
set listchars=tab:,.,trail:.,extends:>,precedes:<,nbsp:. " Highlight problematic whitespace
set ignorecase
set smartcase
set shellslash

" Setup cache directories {
    function! InitializeDirectories()
      " Specify a directory in which to place the vimbackup, vimviews, vimundo, and vimswap files/directories.
      let dir_list = {
          \ 'backup': 'backupdir',
          \ 'views': 'viewdir',
          \ 'swap': 'directory',
          \ 'undo': 'undodir' }

      if WINDOWS()
        let g:viminfo_filename = substitute($MYCACHEDIR, '\\', '\\\\', 'g') . '\\viminfo'
      else
        let g:viminfo_filename = $MYCACHEDIR . '/viminfo'
      endif

      exec "set viminfo='100,n" . g:viminfo_filename

      for [dirname, settingname] in items(dir_list)
          if WINDOWS()
              let directory = $MYCACHEDIR . '\' . dirname
          else
              let directory = $MYCACHEDIR . '/' . dirname
          endif

          if exists("*mkdir")
              if !isdirectory(directory)
                call mkdir(directory, 'p')
              endif
          endif

          let directory = substitute(directory, ' ', '\\\\ ', "g")
          exec 'set ' . settingname . '=' . directory
      endfor
  endfunction

  call InitializeDirectories()
" }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key-Bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-P> :FZFFiles<CR>

nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k

tnoremap <Esc> <C-\><C-n>

" incsearch.vim
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
