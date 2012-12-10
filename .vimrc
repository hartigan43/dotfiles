set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
 Bundle 'gmarik/vundle'
 Bundle 'tpope/vim-fugitive'
 Bundle 'tpope/vim-rails'
 Bundle 'tpope/vim-haml'
 Bundle 'tpope/vim-surround'
 Bundle 'pangloss/vim-javascript'
 Bundle 'Lokaltog/vim-powerline'

filetype plugin indent on "req

let g:Powerline_symbols = 'fancy'  "powerline fix for proper font disply

colorscheme syn_off_dark

"syntax enable
set term=screen-256color
set number
set ts=2
set shiftwidth=2
set autoindent
set smarttab
set expandtab
set showmatch
set encoding=utf-8
set laststatus=2
set noshowmode

"disable arrow keys / ctrl + hjkl window swap
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

if has('gui_running')
  set guifont=Inconsolata\ 10    " set fonts for gui vim
  set guioptions=egmrt           " hide the gui menubar
  colorscheme syn_off_dark
endif
