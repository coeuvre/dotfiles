" Environment {
  if &compatible
    set nocompatible
  endif

  silent function! OSX()
    return has('macunix')
  endfunction

  silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
  endfunction

  silent function! WIN32()
    return  has('win16') || has('win32') || has('win64')
  endfunction

  silent function! MINGW()
    return has('win32unix')
  endfunction

  silent function! UNIX()
    return OSX() || LINUX()
  endfunction

  silent function! GUI()
    return has('gui')
  endfunction

  silent function! TMUX()
    return !GUI() && exists('$TMUX')
  endfunction

  silent function! NVIM()
    return has('nvim')
  endfunction

  let $MYVIMRCDIR = fnamemodify($MYVIMRC, ':p:h')

  if WIN32()
    let $MYCACHEDIR = $MYVIMRCDIR . '\cache'
    let $DEINDIR = $MYVIMRCDIR . '\dein'
  else
    let $MYCACHEDIR = $HOME . '/.cache/nvim'
    let $DEINDIR = $MYCACHEDIR . '/dein'
  endif
" }

" Plugin Management {
  let $DEINREPODIR = $DEINDIR . '/repos/github.com/Shougo/dein.vim'

  " Required:
  execute 'set runtimepath+=' . $DEINREPODIR

  " Required:
  if dein#load_state($DEINDIR)
    call dein#begin($DEINDIR)

    " Let dein manage dein
    " Required:
    call dein#add($DEINREPODIR)

    call dein#add('Shougo/deoplete.nvim')
    call dein#add('Shougo/denite.nvim')
    call dein#add('scrooloose/nerdtree')
    call dein#add('mbbill/undotree')
    call dein#add('vim-airline/vim-airline')

    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('wellle/targets.vim')
    call dein#add('tpope/vim-commentary')
    call dein#add('tpope/vim-unimpaired')
    call dein#add('airblade/vim-rooter')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('neomake/neomake')

    call dein#add('rust-lang/rust.vim')

    call dein#add('rakr/vim-one')

    " Required:
    call dein#end()
    call dein#save_state()
  endif

  " Required:
  filetype plugin indent on
  syntax enable

  " If you want to install not installed plugins on startup.
  if dein#check_install()
    call dein#install()
  endif
" }

" Setting {
  set mouse=a                 " Automatically enable mouse usage
  set mousehide               " Hide the mouse cursor while typing
  scriptencoding utf-8

  if has('clipboard')
    if has('unnamedplus') " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
    else
      set clipboard=unnamed
    endif
  endif

  if WIN32()
    set shellslash
  endif

  " Always switch to the current file directory
  "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

  set autowrite                       " Automatically write a file when leaving a modified buffer
  set history=1000                    " Store a ton of history (default is 20)
  set hidden                          " Allow buffer switching without saving
  set autoread
  set number                          " Line numbers on
  set foldmethod=indent
  set nofoldenable
  set showmatch                       " Show matching brackets/parenthesis
  set cursorline                      " Highlight current line
  set nowrap                          " Do not wrap long lines
  set autoindent                      " Indent at the same level of the previous line
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
  set noeb vb t_vb=                   " Close error bells
  set ignorecase
  set smartcase
  set virtualedit=onemore             " Allow for cursor beyond last character

  autocmd GUIEnter * set visualbell t_vb=

  " Remove trailing whitespaces and ^M chars {
    function! StripTrailingWhitespace()
      " Preparation: save last search, and cursor position.
      let _s=@/
      let l = line(".")
      let c = col(".")
      " do the business:
      %s/\s\+$//e
      " clean up: restore previous search history, and cursor position
      let @/=_s
      call cursor(l, c)
    endfunction

    autocmd BufWritePre * call StripTrailingWhitespace()
  " }

  autocmd FileType html,lua,vim setl sts=2 ts=2

  " Instead of reverting the cursor to the last position in the buffer,
  " we set it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " Restore cursor to file position in previous editing session http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session {
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
  " }

  " Setup cache directories {
    function! InitializeDirectories()
      " Specify a directory in which to place the vimbackup, vimviews, vimundo, and vimswap files/directories.
      let dir_list = {
            \ 'backup': 'backupdir',
            \ 'views': 'viewdir',
            \ 'swap': 'directory',
            \ 'undo': 'undodir' }

      if WIN32()
        let g:viminfo_filename = substitute($MYCACHEDIR, '\\', '\\\\', 'g') . '\\viminfo'
      else
        let g:viminfo_filename = $MYCACHEDIR . '/viminfo'
      endif

      exec "set viminfo='100,n" . g:viminfo_filename

      for [dirname, settingname] in items(dir_list)
        if WIN32()
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
" }

" UI {
  if has('termguicolors')
    set termguicolors
  endif

  set background=dark
  let g:one_allow_italics = 1
  let g:airline_theme='one'
  colorscheme one

  if has('gui_running')
    set guioptions-=t
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions-=b
    set guioptions-=e
    if LINUX()
      set guifont=Source\ Code\ Pro\ 11,Fira\ Code\ 11,Courier\ New\ Regular\ 18
    elseif OSX()
      set guifont=Source\ Code\ Pro:h14,Fira\ Code:h14,Monaco:h11
    elseif WINDOWS()
      set guifont=Source\ Code\ Pro:h14,Fira\ Code:h11,Consolas:h11
    endif
  else
    if &term == 'xterm' || &term == 'screen'
      set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    endif
  endif
" }

" Key Mappings {
  let mapleader = "\<Space>"

  " No need for ex mode
  nnoremap Q <nop>

  nnoremap <C-H> <C-W>h
  nnoremap <C-L> <C-W>l
  nnoremap <C-J> <C-W>j
  nnoremap <C-K> <C-W>k

  tnoremap <Esc> <C-\><C-n>

  nmap <Leader>mm :Denite menu<CR>
  nmap <Leader>bb :Denite buffer<CR>
  nmap <Leader>ff :Denite file_rec<CR>
  nmap <Leader>fr :Denite file_old<CR>
  nmap <Leader>fg :Denite grep<CR>

  " Search for selected text http://vim.wikia.com/wiki/VimTip171 {
    let s:save_cpo = &cpo | set cpo&vim
    if !exists('g:VeryLiteral')
      let g:VeryLiteral = 0
    endif
    function! s:VSetSearch(cmd)
      let old_reg = getreg('"')
      let old_regtype = getregtype('"')
      normal! gvy
      if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
        let @/ = @@
      else
        let pat = escape(@@, a:cmd.'\')
        if g:VeryLiteral
          let pat = substitute(pat, '\n', '\\n', 'g')
        else
          let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
          let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
          let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
        endif
        let @/ = '\V'.pat
      endif
      normal! gV
      call setreg('"', old_reg, old_regtype)
    endfunction
    vnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR>
    vnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>/<CR>
    vmap <kMultiply> *
    nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
          \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
    let &cpo = s:save_cpo | unlet s:save_cpo
  " }
" }

" Plugin: deoplete {
  " Use deoplete.
  let g:deoplete#enable_at_startup = 1
  " Use smartcase.
  let g:deoplete#enable_smart_case = 1

  " Use Tab to select completion
  inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function() abort
          return deoplete#close_popup() . "\<CR>"
  endfunction
" }

" Plugin: denite {
  if executable('ag')
    " For the silver searcher
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  elseif executable('rg')
    " For ripgrep
    call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  elseif executable('pt')
    " For Pt(the platinum searcher)
    call denite#custom#var('file_rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', (has('win32') ? '-g:' : '-g='), ''])

    call denite#custom#var('grep', 'command', ['pt'])
    call denite#custom#var('grep', 'default_opts', ['--nogroup', '--nocolor', '--smart-case'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  endif

  " Change mappings.
  call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')

  " Change matchers.
  call denite#custom#source('file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
  call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])

  " Change sorters.
  call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])

  " Define alias
  call denite#custom#alias('source', 'file_rec/git', 'file_rec')
  call denite#custom#var('file_rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])

  " Change default prompt
  call denite#custom#option('default', 'prompt', '>')

  " Change ignore_globs
  call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
        \ [ '.git/', '.ropeproject/', '__pycache__/',
        \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
" }

" Plugin: vim-rooter {
  let g:rooter_change_directory_for_non_project_files = 'current'
  let g:rooter_silent_chdir = 1
  let g:rooter_use_lcd = 1
" }

" Plugin: Neomake {
  let g:neomake_open_list = 2
" }
