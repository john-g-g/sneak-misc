syntax on
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
noremap  <Left> ""
noremap! <Left> <Esc>
noremap  <Right> ""
noremap! <Right> <Esc>

" then define two autocommands
au InsertEnter * hi StatusLine term=reverse guibg=#005000
au InsertLeave * hi StatusLine term=reverse guibg=#444444
set number
set tw=75
set encoding=utf-8
setglobal fileencoding=utf-8
set nobomb
set termencoding=utf-8
set fileencodings=utf-8,iso-8859-15
set backspace=indent,eol,start

set modeline
"set statusline=%F%m%r%h%w\ [\%03.3b]\ [\%02.2B]\ [l%l,c%v][%p%%]\ [%L]

set laststatus=2

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smarttab
set expandtab
autocmd FileType make setlocal noexpandtab

let Tlist_Inc_Winwidth = 0

if has("autocmd") 
    au BufReadPost * if &modifiable | retab | endif 
endif 

set showcmd
set nocompatible

" Folding Stuffs
set foldmethod=marker

set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

set ignorecase
set smartcase
inoremap jj <Esc>
set incsearch
set hlsearch

map N Nzz
map n nzz

map _t :TlistToggle<cr>

set cul
"hi CursorLine term=none cterm=none ctermbg=none
"set t_Co=256
