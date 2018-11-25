""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Environments
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

silent function! WINDOWS()
    return  has('win32') || has('win64')
endfunction

if WINDOWS()
    let $PLUGDIR = $HOME . '\AppData\Local\nvim\plugged'
    let $MYCACHEDIR = $HOME . '\AppData\Local\nvim\cache'
else
    let $PLUGDIR = $HOME . '/.local/share/nvim/plugged'
    let $MYCACHEDIR = $HOME . '/.cache/nvim'
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
Plug 'skywind3000/asyncrun.vim' " {
    let g:asyncrun_open=10
    let g:asyncrun_save=2
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
    inoremap <expr> <cr> (pumvisible() ? "\<c-y>\<cr>" : "\<cr>")

    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"<Paste>
" }

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'

Plug 'rust-lang/rust.vim'

" GUI
Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'

call plug#end()

set background=dark
silent! colorscheme base16-tomorrow-night

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
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

" Instead of reverting the cursor to the last position in the buffer,
" we set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Restore cursor to file position in previous editing session http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
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

" Setup cache directories
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
        let directory = substitute(directory, ' ', '\\\\ ', "g")

        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory, 'p')
            endif
        endif

        exec 'set ' . settingname . '=' . directory
    endfor
endfunction

call InitializeDirectories()

" Search for selected text.
" http://vim.wikia.com/wiki/VimTip171
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
if !hasmapto("<Plug>VLToggle")
    nmap <unique> <Leader>vl <Plug>VLToggle
endif
let &cpo = s:save_cpo | unlet s:save_cpo

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key-Bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"

nnoremap <c-p> :FZFGFiles<cr>

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <c-q> :copen<cr>
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>

nnoremap <leader><tab> :b#<cr>
nnoremap <leader>bb :FZFBuffers<cr>
nnoremap <leader>ff :FZFFiles<cr>
nnoremap <leader>fs :w<cr>
nnoremap <leader>fr :FZFHistory<cr>
nnoremap <leader>fg :FZFRg<cr>

tnoremap <esc> <c-\><c-n>
autocmd FileType fzf tnoremap <nowait><buffer> <esc> <c-g>
autocmd FileType qf nnoremap <nowait><buffer> q <c-w>c

function SetRustKeyBindings()
    nnoremap <buffer> <leader>m :AsyncRun cargo build<cr>
    nnoremap <buffer> <leader>r :AsyncRun cargo run<cr>
    nnoremap <buffer> <leader>= :RustFmt<cr>
endfunction

autocmd FileType rust call SetRustKeyBindings()

" incsearch.vim
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
