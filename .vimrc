if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'ap/vim-buftabline'
Plug 'prabirshrestha/vim-lsp'
Plug 'jpalardy/vim-slime'
Plug 'vim-scripts/DrawIt'
Plug 'preservim/tagbar'
Plug 'kien/ctrlp.vim'
call plug#end()

syntax on

" The things we do for 256 color...
if has("termguicolors")
     set termguicolors
     set t_Co=256
     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

" Indentation
set autoindent
set cindent
autocmd FileType cpp setlocal cindent tabstop=2 shiftwidth=2 expandtab

set textwidth=0
set wrapmargin=0
set wrap
set linebreak
set columns=80

" Misc
set scrolloff=2
set nomore
set cpoptions-=a
set autowrite       "Save buffer automatically when changing files
set autoread        "Always reload buffer when external changes detected
set backspace=indent,eol,start      "BS past autoindents, line boundaries,
set wildignorecase                  "Case-insensitive completions
set wildmenu
set infercase                       "Adjust completions to match case
set noshowmode                      "Suppress mode change messages
set updatecount=10                  "Save buffer every 10 chars typed

" Search
set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       " ...unless uppercase letters used

set hlsearch        "Highlight all matches
hi clear Search
hi       Search    ctermfg=White  cterm=bold
hi    IncSearch    ctermfg=White  ctermbg=Red    cterm=bold

nnoremap <silent> <BS> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" 80 characters line
call matchadd('ColorColumn', '\%81v.', 100)

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=Red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"set lcs=tab:»·,trail:·,nbsp:˷
set lcs=tab:»·,nbsp:˷
hi SpecialKey ctermfg=grey

"" Set 7 lines to the cursor - when moving vertically using j/k
set so=7
"
"" Show matching brackets when text indicator is over them
set showmatch

"" How many tenths of a second to blink when matching brackets
set mat=2

" turn hybrid line numbers on
"set number relativenumber
set nu rnu

" Terminal debugging setup
packadd termdebug
let g:termdebugger = "gdb-multiarch"
hi! link debugPC Visual
hi! link debugBreakpoint Visual
"let g:termdebug_popup = 0
"
" File explorer
if &columns < 90
  " If the screen is small, occupy half
  let g:netrw_winsize = 40
else
  " else take 30%
  let g:netrw_winsize = 25
endif
let g:netrw_liststyle = 3
let g:netrw_banner = 0
nnoremap ge :Lexplore <CR>
nnoremap gE :Lexplore %:p:h <CR>

" Make vertical separator pretty
"set fillchars+=vert:\
set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE

" Statusline
hi! link StatusLineNC Tabline
hi TabLineSel guifg=white cterm=bold
hi! link PmenuSel Tabline
hi StatusLine guifg=#cccccc
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

set laststatus=2
set statusline=
set statusline +=\ %<%F%*            "full path
set statusline +=%=%5l%*             "current line
set statusline +=/%L%*               "total lines
set statusline +=%4v\ %*             "virtual column number
set statusline +=\ %y%*              "file type
set statusline +=\ %{&ff}%*          "file format
set statusline +=\ \ %m%r%w\ %P\ \   "Modified? Readonly? Top/bot.

hi clear LineNr
hi clear SignColumn
hi clear CursorLineNR
highlight LineNr ctermfg=grey
highlight SignColumn ctermfg=grey
highlight CursorLineNR ctermfg=yellow

" Fold
let g:markdown_folding=1
au FileType markdown setlocal foldlevel=99
function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let line = getline(v:foldstart)
    let comment = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    let expansionString = repeat(".", w - strwidth(nblines.comment.'"'))
    let txt = '"' . comment . expansionString . nblines
    return txt
endfunction
set foldtext=MyFoldText()

" Extensions

" Slime
autocmd FileType python let b:slime_vimterminal_cmd='python3'
autocmd FileType python let g:slime_target = "vimterminal"
autocmd FileType python let g:slime_cell_delimiter = "^\\s*# %%"
let g:slime_vimterminal_config = {"term_finish": "close"}
nmap <buffer> <c-c><c-c> <Plug>SlimeSendCell
nmap <buffer> <c-k><c-k> <Plug>SlimeLineSend1

" Language server protocol setup
if executable('pylsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

if executable('efm-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'efm-langserver',
        \  'cmd': {server_info->['efm-langserver', '-c', glob('~/.efm.yaml')]},
        \ 'whitelist': ['sh', 'json', 'markdown'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal signcolumn=yes
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> gR <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> gK <plug>(lsp-hover-preview)
    nmap <buffer> gF <plug>(lsp-document-format)
    nmap <buffer> gT <plug>(lsp-type-hierarchy)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)
endfunction

highlight link LspErrorText LineNr
highlight link LspWarningHighlight LineNr
highlight link LspWarningText LineNr
highlight link LspInformation LineNr
highlight link LspHint LineNr

let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_signs_information = {'text': 'i'}
let g:lsp_diagnostics_signs_hint = {'text': 'i'}
let g:lsp_document_code_action_signs_hint = {'text': '>'}
let g:lsp_preview_doubletap = [function('lsp#ui#vim#output#closepreview')]
let g:lsp_preview_float = 0
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_signature_help_enabled = 0
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.vim-lsp.log')
autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

silent !stty -ixon
let g:tagbar_compact = 1
nmap <c-q> :TagbarToggle<CR>

if isdirectory($HOME . '/.vim/swap-files') == 0
    :silent !mkdir -p ~/.vim/swap-files > /dev/null 2>&1
endif


" Strip trailing white spaces --- {{{
" http://vimcasts.org/episodes/tidying-whitespace/
command! -nargs=* StripTrailingWhitespaces call StripTrailingWhitespaces()
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }}}
