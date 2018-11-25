""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Environments
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

silent function! WINDOWS()
    return has('win32') || has('win64')
endfunction

let $MYVIMRCDIR = fnamemodify($MYVIMRC, ':p:h')

if WINDOWS()
    let $MYCACHEDIR = $MYVIMRCDIR . '\cache'
    let $DEINDIR = $MYVIMRCDIR . '\dein'
else
    let $MYCACHEDIR = $HOME . '/.cache/nvim'
    let $DEINDIR = $MYCACHEDIR . '/dein'
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let $DEINREPODIR = $DEINDIR . '/repos/github.com/Shougo/dein.vim'

execute 'set runtimepath+=' . $DEINREPODIR
filetype off

if dein#load_state($DEINDIR)
    call dein#begin($DEINDIR)

    call dein#add($DEINREPODIR)

    " VIM Enhancements
    call dein#add('tpope/vim-sensible')
    call dein#add('machakann/vim-highlightedyank') " {
        let g:highlightedyank_highlight_duration = 100
    " }
    call dein#add('haya14busa/incsearch.vim') " {
        let g:incsearch#auto_nohlsearch = 1
    " }
    call dein#add('ntpeters/vim-better-whitespace') " {
        let g:better_whitespace_enabled=1
        let g:strip_whitespace_on_save=1
    " }
    call dein#add('skywind3000/asyncrun.vim') " {
        let g:asyncrun_open=10
        let g:asyncrun_save=2
    " }
    call dein#add('airblade/vim-rooter')

    " Fuzzy Finder
    call dein#add('Shougo/denite.nvim') " {
        if executable('rg')
            " For ripgrep
            call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

            call denite#custom#var('grep', 'command', ['rg'])
            call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
            call denite#custom#var('grep', 'recursive_opts', [])
            call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
            call denite#custom#var('grep', 'separator', ['--'])
            call denite#custom#var('grep', 'final_opts', [])
        endif

        " Change mappings.
        call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
        call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

        " Change matchers.
        call denite#custom#source('file/mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
        call denite#custom#source('file/rec', 'matchers', ['matcher_cpsm'])

        " Change sorters.
        call denite#custom#source('file/rec', 'sorters', ['sorter_sublime'])

        " Define alias
        call denite#custom#alias('source', 'file/rec/git', 'file/rec')
        call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])

        " Change default prompt
        call denite#custom#option('default', 'prompt', '>')

        " Change ignore_globs
        call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
                    \ [ '.git/', '.ropeproject/', '__pycache__/',
                    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
    " }

    " Completion
    call dein#add('Shougo/deoplete.nvim') " {
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

    " Languages
    call dein#add('rust-lang/rust.vim')

    " GUI
    call dein#add('itchyny/lightline.vim')
    call dein#add('chriskempson/base16-vim')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key-Bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"

nnoremap <c-p> :Denite file/rec<cr>

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <c-q> :copen<cr>
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>

nnoremap <leader><tab> :b#<cr>
nnoremap <leader>fs :w<cr>
nnoremap <leader>mm :Denite menu<cr>
nnoremap <leader>bb :Denite buffer<cr>
nnoremap <leader>ff :Denite file/rec<cr>
nnoremap <leader>fr :Denite file/old<cr>
nnoremap <leader>fg :Denite grep<cr>

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
