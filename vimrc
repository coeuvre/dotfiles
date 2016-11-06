" Modeline {
" vim: set sw=4 ts=4 sts=4 et tw=78
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
            return  has('win32') || has('win64')
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
    " }

    " Basics {
        set nocompatible
        if !WINDOWS()
            set shell=/bin/sh
        endif

        " Directory that put all the vim data files.
        let s:common_dir = escape($HOME . '/.cache/vim/', ' ')
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles';
        " this makes synchronization across (heterogeneous) systems easier.
        if WINDOWS()
            let $HOME = substitute($HOME, '/', '\\', 'g')
            let s:common_dir = substitute(s:common_dir . 'windows/', '/', '\\', 'g')
            set runtimepath=$HOME\\.vim,$VIM\\vimfiles,$VIMRUNTIME,$VIM\\vimfiles\\after,$HOME\\.vim\\after
        endif
    " }

    function! ShellCommandAnd()
        if empty(matchstr($SHELL, 'fish'))
            return ' && '
        else
            return '; and '
        endif
    endfunction
    let g:coeuvre_shell_cmd_and = ShellCommandAnd()

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" General {

    set background=dark         " Assume a dark background

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

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set autoread                        " When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
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

    set tabpagemax=15               " Only show 15 tabs
    set showmode

    "set cursorline                  " Highlight current line
    "set colorcolumn=80

    " Highlight for GitGutter
    highlight clear SignColumn      " SignColumn should match background for things like vim-gitgutter
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    highlight clear CursorLineNr    " Remove highlight color from current line number

    highlight Search guibg=yellow gui=underline ctermbg=yellow cterm=underline

    " Highlight task tags {
        highlight Important ctermfg=Yellow cterm=underline,bold guifg=#FFFF00 gui=underline,bold
        autocmd WinEnter,Syntax * call matchadd('Important', '\W\zs\(IMPORTANT\|HACK\)')

        highlight Note ctermfg=Green cterm=underline,bold guifg=#00FF00 gui=underline,bold
        autocmd WinEnter,Syntax * call matchadd('Note', '\W\zs\(NOTE\|INFO\|IDEA\)')

        highlight clear Todo
        highlight Todo ctermfg=Red cterm=underline,bold guifg=#FF0000 gui=underline,bold
        autocmd WinEnter,Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|BUG\)')
    " }

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_spf13_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    "set number                      " Line numbers on
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
    set listchars=tab:,.,trail:.,extends:>,precedes:<,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=0                " use 'ts' value
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
    set cinoptions=l1,(0,W1s,m1     " set C indent options

    set fileformats=unix,dos        " always create unix file

    " Remove trailing whitespaces and ^M chars
    autocmd BufWritePre * call StripTrailingWhitespace()

    autocmd FileType html setl sts=2 ts=2

" }

" Key (re)Mappings {

    " The default leader is '\', but I prefer 'Space'
    let mapleader = "\<space>"

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    "map <c-j> <c-w>j<c-w>_
    "map <c-k> <c-w>k<c-w>_
    "map <c-l> <c-w>l<c-w>_
    "map <c-h> <c-w>h<c-w>_

    " No need for ex mode
    nnoremap Q <nop>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases {
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
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    " }

    map <S-H> gT
    map <S-L> gt

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
    set foldmethod=manual
    "nmap <leader>0 :set foldlevel=0<CR>
    "nmap <leader>1 :set foldlevel=1<CR>
    "nmap <leader>2 :set foldlevel=2<CR>
    "nmap <leader>3 :set foldlevel=3<CR>
    "nmap <leader>4 :set foldlevel=4<CR>
    "nmap <leader>5 :set foldlevel=5<CR>
    "nmap <leader>6 :set foldlevel=6<CR>
    "nmap <leader>7 :set foldlevel=7<CR>
    "nmap <leader>8 :set foldlevel=8<CR>
    "nmap <leader>9 :set foldlevel=9<CR>

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

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Insert <CR> at current cursor.
    nmap <S-CR> i<CR><Esc>

    " Spell checking
    "map <leader>ss :setlocal spell!<cr>
    "map <leader>sn ]s
    "map <leader>sp [s
    "map <leader>sa zg
    "map <leader>s= z=

    vmap <silent> <tab> =

    " Spacemacs like key-bindings {
        " Define prefix dictionary
        let g:leader =  {}
        nnoremap <silent> <leader> :<c-u>LeaderGuide '<space>'<cr>
        "vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<space>'<cr>

        " Quit {
            let g:leader.q = { 'name': '+Quit' }

            nmap <silent> <leader>qq :xa<cr>
            let g:leader.q.q = ['xa', 'Save and Quit']
        " }

        " Window {
            let g:leader.w = { 'name': '+Windows' }

            nmap <silent> <leader>wv :wincmd v<cr>
            let g:leader.w.v = ['wincmd v', 'Split Right']
            nmap <silent> <leader>ws :wincmd s<cr>
            let g:leader.w.s = ['wincmd s', 'Split Below']

            nmap <silent> <leader>wm :only<cr>
            let g:leader.w.m = ['only', 'Maximize']
            nmap <silent> <leader>wd :wincmd c<cr>
            let g:leader.w.d = ['wincmd c', 'Delete']

            nmap <silent> <leader>ww :wincmd w<cr>
            let g:leader.w.w = ['wincmd w', 'Other']
            nmap <silent> <leader>wh :wincmd h<cr>
            let g:leader.w.h = ['wincmd h', 'Left']
            nmap <silent> <leader>wj :wincmd j<cr>
            let g:leader.w.j = ['wincmd j', 'Down']
            nmap <silent> <leader>wk :wincmd k<cr>
            let g:leader.w.k = ['wincmd k', 'Up']
            nmap <silent> <leader>wl :wincmd l<cr>
            let g:leader.w.l = ['wincmd l', 'Right']
            nmap <silent> <leader>wH :wincmd H<cr>
            let g:leader.w.H = ['wincmd H', 'Move Left']
            nmap <silent> <leader>wJ :wincmd J<cr>
            let g:leader.w.J = ['wincmd J', 'Move Down']
            nmap <silent> <leader>wK :wincmd K<cr>
            let g:leader.w.K = ['wincmd K', 'Move Up']
            nmap <silent> <leader>wL :wincmd L<cr>
            let g:leader.w.L = ['wincmd L', 'Move Right']

            nmap <silent> <leader>w= :wincmd =<cr>
            let g:leader.w['='] = ['wincmd =', 'Balance']
        " }

        " Files {
            let g:leader.f = { 'name': '+Files' }

            nmap <silent> <leader>fs :w<cr>
            let g:leader.f.s = ['w', 'Save']
            nmap <silent> <leader>fS :wa<cr>
            let g:leader.f.S = ['wa', 'Save All']
            nmap <silent> <leader>fr :CtrlPMRUFiles<cr>
            let g:leader.f.r = ['CtrlPMRUFiles', 'Recent']

            nmap <silent> <leader>ft :NERDTree<cr>
            let g:leader.f.t = ['NERDTree', 'Tree']
            map <silent> <C-\> <leader>ft
        " }

        " Buffers {
            let g:leader.b = { 'name': '+Buffers' }

            nmap <silent> <leader>bb :CtrlPBuffer<CR>
            let g:leader.b.b = ['CtrlPBuffer', 'List']

            nmap <silent> <leader>bd :BD<CR>
            let g:leader.b.d = ['BD', 'Delete']

            nmap <silent> <leader>bd :BD<CR>
            let g:leader.b.D = ['bufdo :BD', 'Delete All']
        " }

        " Projects {
            let g:leader.p = { 'name': '+Projects' }

            noremap <silent> <leader>pf :CtrlP<CR>
            let g:leader.p.f = ['CtrlP', 'Find']

            nmap <silent> <leader>pt :ProjectRootExe NERDTree<cr>
            let g:leader.p.t = ['ProjectRootExe NERDTree', 'Tree']

            nmap <silent> <leader>ps :call ProjectRootGrepInteractive()<cr>
            let g:leader.p.s = ['call ProjectRootGrepInteractive()', 'Search']

            nmap <silent> <leader>pc :call ProjectRootMakeInteractive()<cr>
            let g:leader.p.c = ['call ProjectRootMakeInteractive()', 'Compile']

            nmap <silent> <leader>pr :call ProjectRootRunInteractive()<cr>
            let g:leader.p.r = ['call ProjectRootRunInteractive()', 'Run']
        " }

        " Search {
            let g:leader.s = { 'name': '+Search' }

            nmap <leader>ss :call Swoop()<cr>
            vmap <leader>ss :call SwoopSelection()<cr>
            let g:leader.s.s = ['call Swoop()', 'Swoop']
        " }

        " Comment {
            let g:leader.c = { 'name': '+Compile' }

            nmap <silent> <leader>cr :call RepeatCompile()<cr>
            let g:leader.c.r = ['call RepeatCompile()', 'Repeat']
        " }

        " Toggle {
            let g:leader.t = { 'name': '+Toggle' }

            nmap <leader>tt :NERDTreeToggle<cr>
            let g:leader.t.t = ['NERDTreeToggle', 'Tree']

            " Search {
                let g:leader.t.s = { 'name': '+Search' }

                nmap <unique> <leader>tsl <Plug>VLToggle
                let g:leader.t.s.l = ['call feedkeys("\<Plug>VLToggle")', 'Very Literal']
            " }

            nmap <leader>tc <Plug>NERDCommenterToggle
            vmap <leader>tc <Plug>NERDCommenterToggle
            let g:leader.t.c = ['call feedkeys("\<Plug>NERDCommenterToggle")', 'Comment']
        " }

        " Misc {
            " Find merge conflict markers
            map <leader>m /\v^[<\|=>]{7}( .*\|$)<cr>
            let g:leader.m = ['/\v^[<\|=>]{7}( .*\|$)', 'Find Merge Conlict']

            nmap <leader><tab> :BA<cr>
            let g:leader['<C-I>'] = ['BA', 'Switch Buffer']
        " }
    " }

" }

" Plugins {
    call plug#begin()

    "
    " Core
    "
    Plug 'hecal3/vim-leader-guide'

    Plug 'mhinz/vim-startify' " {
        function! s:filter_header(lines) abort
            let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
            let centered_lines = map(copy(a:lines),
                        \ 'repeat(" ", (80 / 2) - (longest_line / 2)) . v:val')
            return centered_lines
        endfunction

        redir => s:startify_title
        silent version
        redir END
        let s:startify_title = split(s:startify_title, '\n')[0]
        let g:startify_custom_header = s:filter_header([s:startify_title])
            \ + s:filter_header([
            \ '',
            \ '              -------------------------              ',
            \ '             ( Gamer                   )             ',
            \ '             (       ->                )             ',
            \ '             (          Game Developer )             ',
            \ '              -------------------------              ',
            \ '                                 o                   ',
            \ '                                  o  ^__^            ',
            \ '                                     (oo)\_______    ',
            \ '                                     (__)\       )\/\',
            \ '                                         ||----w |   ',
            \ '                                         ||     ||   ',
            \ '',
            \ ])
    " }

    Plug 'Shougo/neocomplete.vim' " {
        let g:neocomplete#data_directory = s:common_dir . 'neocomplete'

        " Disable AutoComplPop.
        let g:acp_enableAtStartup = 0
        " Use neocomplete.
        let g:neocomplete#enable_at_startup = 1
        " Use smartcase.
        let g:neocomplete#enable_smart_case = 1
        " Set minimum syntax keyword length.
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

        " Define dictionary.
        let g:neocomplete#sources#dictionary#dictionaries = {
                    \ 'default' : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }

        " Define keyword.
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'

        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplete#undo_completion()
        inoremap <expr><C-l>     neocomplete#complete_common_string()

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
            " For no inserting <CR> key.
            "return pumvisible() ? "\<C-y>" : "\<CR>"
        endfunction
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

        inoremap <expr><C-j>  pumvisible() ? "\<C-n>" : "\<C-j>"
        inoremap <expr><C-k>  pumvisible() ? "\<C-p>" : "\<C-k>"

        " <C-h>, <BS>: close popup and delete backword char.
        "inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        " Close popup by <Space>.
        "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

        " AutoComplPop like behavior.
        "let g:neocomplete#enable_auto_select = 1

        " Shell like behavior(not recommended).
        "set completeopt+=longest
        "let g:neocomplete#enable_auto_select = 1
        "let g:neocomplete#disable_auto_complete = 1
        "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

        " Enable heavy omni completion.
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        "let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    " }

    Plug 'dbakker/vim-projectroot'

    Plug 'mileszs/ack.vim' " {
        if executable('pt')
          let g:ackprg = 'pt --nogroup --column'
        elseif executable('ag')
          let g:ackprg = 'ag --vimgrep'
        endif
    " }

    Plug 'ctrlpvim/ctrlp.vim' " {
        let g:ctrlp_cache_dir = s:common_dir . 'ctrlp'

        if WINDOWS()
            set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
        else
            set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
        endif

        let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

        " The Silver Searcher
        if executable('pt')
            " Use pt over grep
            set grepprg=pt\ --nogroup\ --nocolor

            " Use pt in CtrlP for listing files. Lightning fast and respects .gitignore
            let g:ctrlp_user_command += ['pt %s -l --nocolor --hidden -g ""']
        elseif executable('ag')
            " Use ag over grep
            set grepprg=ag\ --nogroup\ --nocolor

            " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
            let g:ctrlp_user_command += ['ag %s -l --nocolor --hidden -g ""']
        endif
    " }

    Plug 'scrooloose/nerdtree'

    Plug 'mbbill/undotree'

    Plug 'scrooloose/nerdcommenter' " {
        let g:NERDCreateDefaultMappings = 0
        let g:NERDCustomDelimiters = {
            \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '// '}
        \ }
    " }

    if executable('editorconfig')
        Plug 'editorconfig/editorconfig-vim'
    endif

    "Plug 'pelodelfuego/vim-swoop' " {
        "let g:swoopUseDefaultKeyMap = 0
    "" }

    "Plug 'tpope/vim-fugitive'

    "Plug 'airblade/vim-gitgutter' " {
        "let g:gitgutter_map_keys = 0
    "" }

    Plug 'qpkorr/vim-bufkill'

    "
    " Key
    "
    Plug 'terryma/vim-multiple-cursors'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-repeat'
    Plug 'rhysd/clever-f.vim'
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

    "
    " Visual
    "
    Plug 'bling/vim-airline' " {
        let g:airline_left_sep=''
        let g:airline_right_sep=''

        "let g:airline#extensions#tabline#enabled = 1
        "let g:airline#extensions#tabline#show_buffers = 0
        "let g:airline#extensions#tabline#show_tabs = 1
        "let g:airline#extensions#tabline#show_tab_nr = 0
        "let g:airline#extensions#tabline#left_sep = ''
        "let g:airline#extensions#tabline#_alt_sep = ''
        "let g:airline#extensions#tabline#show_tab_type = 0

        let g:airline#extensions#hunks#non_zero_only = 1

        let g:airline_detect_iminsert=2
        "let g:airline_powerline_fonts = 1
    " }

    Plug 'chriskempson/vim-tomorrow-theme'

    "
    " Syntax
    "
    Plug 'rust-lang/rust.vim'
    Plug 'tikhomirov/vim-glsl'
    Plug 'tpope/vim-markdown'
    Plug 'elzr/vim-json'
    Plug 'cespare/vim-toml'
    Plug 'jelera/vim-javascript-syntax'

    call plug#end()

    " Post Plugin {
        colorscheme Tomorrow-Night
        call leaderGuide#register_prefix_descriptions("<Space>", "g:leader")
    " }

" }

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
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
        set lines=48 columns=80
        if LINUX()
            set guifont=Fira\ Code\ 11,Courier\ New\ Regular\ 18
        elseif OSX()
            set macligatures
            set guifont=Fira\ Code:h14,Monaco:h11
        elseif WINDOWS()
            set guifont=Fira\ Code:h11,Consolas:h11
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {
    " Initialize cache directories {
        function! InitializeDirectories(common_dir)
            " Specify a directory in which to place the vimbackup, vimviews, vimundo, and vimswap files/directories.
            let dir_list = {
                        \ 'backup': 'backupdir',
                        \ 'views': 'viewdir',
                        \ 'swap': 'directory' }

            if has('persistent_undo')
                let dir_list['undo'] = 'undodir'
            endif

            if WINDOWS()
                let viminfo_filename = substitute(a:common_dir, '\\', '\\\\', 'g') . 'viminfo'
            else
                let viminfo_filename = a:common_dir . 'viminfo'
            endif

            exec "set viminfo='100,n" . viminfo_filename

            for [dirname, settingname] in items(dir_list)
                let directory = a:common_dir . dirname . '/'
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

        call InitializeDirectories(s:common_dir)
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
        let &cpo = s:save_cpo | unlet s:save_cpo
    " }

    function! ProjectRootGrepInteractive()
        call inputsave()
        if exists('g:project_root_grep_last_pattern')
            let pattern = input('Search: ', g:project_root_grep_last_pattern)
        else
            let pattern = input('Search: ')
        endif
        call inputrestore()
        if pattern != ""
            let g:project_root_grep_last_pattern = pattern
            execute 'ProjectRootExe LAck! ' . g:project_root_grep_last_pattern
        endif
    endfunction

    function! ProjectRootMakeInteractive()
        call inputsave()
        if exists('g:project_root_make_last_cmd')
            let cmd = input('Compile: ', g:project_root_make_last_cmd)
        else
            let cmd = input('Compile: ')
        endif
        call inputrestore()
        if cmd != ""
            let g:project_root_make_last_cmd = cmd
            let g:last_makeprg = 'cd ' . projectroot#guess() . ShellCommandAnd() . g:project_root_make_last_cmd
            let &makeprg = g:last_makeprg
            execute 'wa | silent make'
        endif
    endfunction

    function! ProjectRootRunInteractive()
        call inputsave()
        if exists('g:project_root_run_last_cmd')
            let cmd = input('Run: ', g:project_root_run_last_cmd)
        else
            let cmd = input('Run: ')
        endif
        call inputrestore()
        if cmd != ""
            let g:project_root_run_last_cmd = cmd
            execute 'ProjectRootExe !Start ' . g:project_root_run_last_cmd
        endif
    endfunction

    function! RepeatCompile()
        if exists('g:last_makeprg')
            let &makeprg = g:last_makeprg
            execute 'wa | silent make'
        endif
    endfunction
" }


" Buildings {
    " Automatically open, but do not go to (if there are errors) the quickfix /
    " location list window, or close it when is has become empty.
    "
    " Note: Must allow nesting of autocmds to enable any customizations for quickfix
    " buffers.
    " Note: Normally, :cwindow jumps to the quickfix window if the command opens it
    " (but not if it's already open). However, as part of the autocmd, this doesn't
    " seem to happen.
    autocmd QuickFixCmdPost [^l]* nested botright cwindow
    autocmd QuickFixCmdPost    l* nested botright lwindow
    autocmd BufReadPost quickfix nnoremap <buffer> q <c-w>c

    " Visual Studio {
        " Compile
        let &errorformat = '%f(%l): %trror C%n: %m'
        let &errorformat .= ',%f(%l): fatal %trror C%n: %m'
        let &errorformat .= ',%f(%l): %tarning C%n: %m'

        " Link
        let &errorformat .= ',%.%#%trror LNK%n: %m'
    " }
" }
