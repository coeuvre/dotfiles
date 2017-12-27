if &compatible
  set nocompatible
endif

" Identify platform {
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
" }

let $MYVIMRCDIR = fnamemodify($MYVIMRC, ':p:h')

if WIN32()
  let $MYCACHEDIR = $MYVIMRCDIR . '\cache'
  let $DEINDIR = $MYVIMRCDIR . '\dein'
else
  let $MYCACHEDIR = $HOME . '/.cache/nvim'
  let $DEINDIR = $HOME . '/.cache/dein'
endif

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
  
    "" Add or remove your plugins here:
    "call dein#add('Shougo/neosnippet.vim')
    "call dein#add('Shougo/neosnippet-snippets')
  
    "" You can specify revision/branch/tag.
    "call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

    call dein#add('Shougo/deoplete.nvim')
  
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
