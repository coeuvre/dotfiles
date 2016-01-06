" Modeline {
" vim: set sw=4 ts=4 sts=4 et :
" }

" Environment {
    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction

        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction

        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles';
        " this makes synchronization across (heterogeneous) systems easier.
        if WINDOWS()
          let $HOME=$VIM
        endif
    " }

    " The default leader is '\', but many people prefer ',' as it's in a standard location.
    let mapleader = "\<Space>"
" }

" Plugins {
    call plug#begin()

    " functionalities
    Plug 'mhinz/vim-startify'

    Plug 'Shougo/deoplete.nvim' " {
        let g:deoplete#enable_at_startup = 1
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " }

    Plug 'ctrlpvim/ctrlp.vim' " {
        nnoremap <silent> <leader>ff :CtrlP<CR>
        nnoremap <silent> <leader>fr :CtrlPMRU<CR>
        nnoremap <silent> <leader>fb :CtrlPBuffer<CR>
    " }

    Plug 'tpope/vim-repeat'

    Plug 'mbbill/undotree'

    Plug 'scrooloose/nerdcommenter'

    "Plug 'tpope/vim-fugitive' " {
    "    nnoremap <silent> <leader>gs :Gstatus<CR>
    "    nnoremap <silent> <leader>gd :Gdiff<CR>
    "    nnoremap <silent> <leader>gc :Gcommit<CR>
    "    nnoremap <silent> <leader>gb :Gblame<CR>
    "    nnoremap <silent> <leader>gl :Glog<CR>
    "    nnoremap <silent> <leader>gp :Git push<CR>
    " }

    Plug 'haya14busa/incsearch.vim' " {
        let g:incsearch#auto_nohlsearch = 1
        " n and N directions are always forward and backward respectively even after performing <Plug>(incsearch-backward).
        let g:incsearch#consistent_n_direction = 1

        map /  <Plug>(incsearch-forward)
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)
        map n  <Plug>(incsearch-nohl-n)
        map N  <Plug>(incsearch-nohl-N)
        map *  <Plug>(incsearch-nohl-*)
        map #  <Plug>(incsearch-nohl-#)
        map g* <Plug>(incsearch-nohl-g*)
        map g# <Plug>(incsearch-nohl-g#)
    " }

    " Key
    Plug 'tpope/vim-unimpaired'

    Plug 'easymotion/vim-easymotion'

    Plug 'terryma/vim-multiple-cursors'

    Plug 'tpope/vim-surround'

    Plug 'kshenoy/vim-signature'

    " Visual
    Plug 'bling/vim-airline' " {
        let g:airline_left_sep=''
        let g:airline_right_sep=''

        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#show_buffers = 0
        let g:airline#extensions#tabline#show_tabs = 1
        let g:airline#extensions#tabline#show_tab_nr = 0

        let g:airline#extensions#tabline#left_sep = ''
        let g:airline#extensions#tabline#_alt_sep = ''

        let g:airline#extensions#hunks#non_zero_only = 1

        let g:airline_detect_iminsert=2
        "let g:airline_powerline_fonts = 1
    " }

    Plug 'kien/rainbow_parentheses.vim' " {
        au VimEnter * RainbowParenthesesToggle
        au Syntax * RainbowParenthesesLoadRound
        au Syntax * RainbowParenthesesLoadSquare
        au Syntax * RainbowParenthesesLoadBraces
    " }

    Plug 'airblade/vim-gitgutter'

    " Syntax
    Plug 'zah/nim.vim'
    Plug 'wting/rust.vim'
    Plug 'tikhomirov/vim-glsl'
    Plug 'tpope/vim-markdown'
    Plug 'elzr/vim-json'
    Plug 'cespare/vim-toml'
    Plug 'jelera/vim-javascript-syntax'

    Plug 'chriskempson/vim-tomorrow-theme'

    call plug#end()
" }

" Gernal {
    set background=dark
    if !has('gui')
        let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    endif

    filetype plugin indent on   " Automatically detect file types
    syntax on                   " Syntax highlighting
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

    " Always switch to the current file directory
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set autoread
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer,
    " we set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
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

    set fileencoding=utf-8
    set noeb vb t_vb=           " Close error bells
    autocmd GUIEnter * set visualbell t_vb=

    set fileencodings=ucs-bom,utf-8,cp936,gb18030

    " Setting up the directories {
        set backup                      " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    " }
" }

" Vim UI {
    colorscheme Tomorrow

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background for things like vim-gitgutter
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    highlight Search guibg=yellow gui=underline
    highlight Search ctermbg=yellow cterm=underline

    set colorcolumn=80
    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info

        " for Syntastic
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    "set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    "set wrap                        " Wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    set cindent                     " do C program indenting

    " Remove trailing whitespaces and ^M chars
    autocmd BufWritePre * call StripTrailingWhitespace()
" }

" Key (re)Mappings {
    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    "map <C-J> <C-W>j<C-W>_
    "map <C-K> <C-W>k<C-W>_
    "map <C-L> <C-W>l<C-W>_
    "map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    "
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap <silent> $ :call WrapRelativeMotion("$")<CR>
    noremap <silent> <End> :call WrapRelativeMotion("$")<CR>
    noremap <silent> 0 :call WrapRelativeMotion("0")<CR>
    noremap <silent> <Home> :call WrapRelativeMotion("0")<CR>
    noremap <silent> ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap <silent> $ v:call WrapRelativeMotion("$")<CR>
    onoremap <silent> <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap <silent> $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <silent> <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <silent> 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <silent> <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <silent> ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

    " Tab operations
    noremap <silent> <leader>tp :tabprevious<cr>
    noremap <silent> <leader>tn :tabnext<cr>
    noremap <silent> <leader>tc :tabclose<cr>
    noremap <silent> <leader>tmh :tabm -1<cr>
    noremap <silent> <leader>tml :tabm +1<cr>

    " Stupid shift key fixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    set foldmethod=syntax
    set foldlevel=9
    nmap <leader>0 :set foldlevel=0<CR>
    nmap <leader>1 :set foldlevel=1<CR>
    nmap <leader>2 :set foldlevel=2<CR>
    nmap <leader>3 :set foldlevel=3<CR>
    nmap <leader>4 :set foldlevel=4<CR>
    nmap <leader>5 :set foldlevel=5<CR>
    nmap <leader>6 :set foldlevel=6<CR>
    nmap <leader>7 :set foldlevel=7<CR>
    nmap <leader>8 :set foldlevel=8<CR>
    nmap <leader>9 :set foldlevel=9<CR>

    " Find merge conflict markers
    map <leader>m /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    "cnoremap %% <C-R>=expand('%:h').'/'<cr>
    "map <leader>ew :e %%
    "map <leader>es :sp %%
    "map <leader>ev :vsp %%
    "map <leader>et :tabe %%

    " Window operations
    noremap <silent> <leader>wv <C-w>v
    noremap <silent> <leader>wV <C-w>V

    noremap <silent> <leader>ws <C-w>s
    noremap <silent> <leader>wS <C-w>S

    noremap <silent> <leader>wc <C-w>c

    " Resize windows
    noremap <silent> <C-w><C-h> :vertical resize -5<CR>
    noremap <silent> <C-w><C-l> :vertical resize +5<CR>
    noremap <silent> <C-w><C-j> :resize +5<CR>
    noremap <silent> <C-w><C-k> :resize -5<CR>

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    "nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Insert <CR> at current cursor.
    nmap <S-CR> i<CR><Esc>

    " Spell checking
    map <leader>ss :setlocal spell!<cr>
    map <leader>sn ]s
    map <leader>sp [s
    map <leader>sa zg
    map <leader>s= z=
" }

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=t
        set guioptions-=T           " Remove the toolbar
        set guioptions-=m
        set guioptions-=r
        set guioptions-=R
        set guioptions-=l
        set guioptions-=L
        set guioptions-=b
        set guioptions-=e
        set lines=56 columns=180
        if LINUX()
            set guifont=Sauce\ Code\ Powerline\ 11,YaHei\ Mono\ for\ Powerline\ 11,YaHei\ Consolas\ Hybrid\ for\ Powerline\ 11,Source\ Code\ Pro\ 11,Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
        elseif OSX()
            set guifont=Monaco:h11,Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
        elseif WINDOWS()
            set guifont=Consolas:h11,Courier_New:h10
        endif

        if OSX()
            set transparency=2      " Make the window slightly transparent
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {
    function! InitializeDirectories()
        " Specify a directory in which to place the vimbackup, vimviews, vimundo, and vimswap files/directories.
        let common_dir = $HOME . '/.cache/nvim/'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        exec "set viminfo='100,<50,s10,h,n" . common_dir . 'viminfo'

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction

    call InitializeDirectories()
    " }

    " Strip whitespace {
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
    " }

    " http://vim.wikia.com/wiki/VimTip171
    " Search for selected text {
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
    " }
" }
