#!/bin/sh

cat > ~/.vimrc <<'EOF'
"execute pathogen#infect()

set number
filetype plugin indent on
syntax on

set modelines=10
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
noremap  <Left> ""
noremap! <Left> <Esc>
noremap  <Right> ""
noremap! <Right> <Esc>
vnoremap > ><CR>gv 
vnoremap < <<CR>gv 

"au BufWinLeave * silent! mkview
"au BufWinEnter * silent! loadview

set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set spelllang=en
set spellfile=~/.vim/spellfile.utf-8.add
set backup
set writebackup
set undofile

au BufRead,BufNewFile *.go set filetype=go
au BufRead,BufNewFile *.coffee set filetype=coffee

let mapleader=","
set tw=76
set encoding=utf-8
setglobal fileencoding=utf-8
set nobomb
set hidden
set termencoding=utf-8
set fileencodings=utf-8,iso-8859-15
set backspace=indent,eol,start
set guifont=Monaco:h16
set modeline
set cmdheight=3
set laststatus=2
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smarttab
set expandtab

autocmd FileType make setlocal noexpandtab
autocmd FileType markdown setlocal spell
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.json set ft=javascript

set ttyfast
set showcmd
set nocompatible
set wildignore+=*.pyc
set ignorecase
set smartcase
inoremap jj <Esc>
map N Nzz
map n nzz
map <s-tab> <c-w><c-w>
colorscheme koehler
hi CursorLine term=none cterm=none ctermbg=none
set t_Co=256
set foldmethod=indent
set foldminlines=5
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <Backspace> :bp<CR>
nnoremap <silent> <Leader><Enter> :ls<CR>

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

let python_no_builtin_highlight = 1
let python_no_doctest_code_highlight = 1
let python_no_doctest_highlight = 1
let python_no_exception_highlight = 1
let python_no_number_highlight = 1
let python_space_error_highlight = 1

let g:flake8_show_in_gutter=1  " show

EOF

mkdir -p ~/.vim/swap
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/undo
