if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'jeffkreeftmeijer/vim-dim'
call plug#end()

set bg=dark
colorscheme dim
syntax on

" 80 characters line
set colorcolumn=81
execute "set colorcolumn=" . join(range(81,335), ',')
highlight ColorColumn ctermbg=Black ctermfg=DarkRed
"
"" Highlight trailing spaces
"" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"" Set 7 lines to the cursor - when moving vertically using j/k
set so=7
"
"" Show matching brackets when text indicator is over them
set showmatch
"" How many tenths of a second to blink when matching brackets
set mat=2

" turn hybrid line numbers on
set number relativenumber
set nu rnu
