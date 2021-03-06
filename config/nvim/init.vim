""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Plugin
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(stdpath('data') . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'} " {
    let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-html',
        \ 'coc-json',
        \ 'coc-rust-analyzer',
        \ 'coc-git',
        \ 'coc-yank',
        \ 'coc-pairs',
        \ 'coc-highlight',
        \ 'coc-tasks',
        \ 'coc-lists']
" }

Plug 'skywind3000/asynctasks.vim' " {
    let g:asynctasks_term_pos = 'tab'
    let g:asynctasks_system = 'macos'
" }

Plug 'skywind3000/asyncrun.vim' " {
    let g:asyncrun_open = 6
" }

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-commentary'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" General
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use system clipboard
set clipboard^=unnamed,unnamedplus

" Space and Tab
set expandtab
set softtabstop=4
set shiftwidth=4

set nowrap

set cursorline

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Get correctly comment highlighting for json file
autocmd FileType json syntax match Comment +\/\/.\+$+

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Theme
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme dracula

if (has("termguicolors"))
    set termguicolors
endif

" Status line
set noshowmode
set laststatus=2

function! LightlineCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightlineGitStatus()
    return get(g:, 'coc_git_status', '')
endfunction

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [
      \      [ 'mode', 'paste' ],
      \      [ 'git', 'filename', 'currentfunction', 'readonly' ],
      \      [ 'cocstatus' ]
      \   ],
      \   'right':[
      \     [  'filetype', 'fileencoding', 'lineinfo', 'percent' ],
      \   ]
      \ },
      \ 'component_function': {
      \   'git': 'LightlineGitStatus',
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'LightlineCurrentFunction'
      \ }
      \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" COC
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[a` and `]a` to navigate diagnostics
nmap <silent> [a <Plug>(coc-diagnostic-prev)
nmap <silent> ]a <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <f2> <Plug>(coc-rename)

" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
"nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Key Mappings
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> <space>g  :<C-u>CocList -I grep<cr>
nnoremap <silent> <space>ff :<C-u>CocList files<cr>
nnoremap <silent> <space>fr :<C-u>CocList mru<cr>
nnoremap <silent> <space>bb :<C-u>CocList buffers<cr>
nnoremap <silent> <space>t  :<C-u>CocList tasks<cr>


nnoremap <silent> <f9> :AsyncTask build<cr>
nnoremap <silent> <f5> :AsyncTask run<cr>

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
