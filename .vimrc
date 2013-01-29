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
" Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim'}
 Bundle 'scrooloose/nerdtree'
 Bundle 'scrooloose/syntastic'
 Bundle 'jistr/vim-nerdtree-tabs'
 Bundle 'msanders/snipmate.vim'

filetype plugin indent on "req

"python from powerline.bindings.vim import source_plugin; source_plugin()
"let g:Powerline_symbols='fancy'  "powerline fix for proper font disply
let g:nerdtree_tabs_open_on_console_startup=1
colorscheme base16-tomorrow

syntax enable
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
set backup
set backupdir=~/.vim/backups
set directory=~/.vim/tmp
set noerrorbells
set timeoutlen=350
set mousehide
set pastetoggle=<F2>

"fold based on indent with max level of 10
set foldmethod=indent  
set foldnestmax=2
set foldenable

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

" javascript folding  http://amix.dk/blog/post/19132
function! JavaScriptFold()
  setl foldmethod=syntax
  setl foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction
  setl foldtext=FoldText()
endfunction
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
