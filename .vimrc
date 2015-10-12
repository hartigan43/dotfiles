filetype off                   " required!
set nocompatible               " be iMproved

call plug#begin('~/.vim/plugged') "load vim-plug

" Vim-plug plugins
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go'
"Plug  'FredKSchott/CoVim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'kien/ctrlp.vim'
"Plug 'Lokaltog/vim-easymotion'
Plug 'majutsushi/tagbar'
Plug 'pangloss/vim-javascript'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sjl/gundo.vim'
Plug 'takac/vim-commandcaps'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe'

call plug#end()

set runtimepath^=~/.vim/bundle/ctrlp.vim

filetype plugin indent on
"filetype indent on

"nerdtree shown on file open
let g:nerdtree_tabs_open_on_console_startup=1

syntax enable
"set term=screen-256color
set t_Co=256 
set number                                        "show line numbers
set background=light
set ts=2                                          "tabs width as two spaces
set shiftwidth=2                                  
set autoindent                                    "keep indentation of current line
set smarttab
set expandtab                                     "converts tabs to spaces
set showmatch
set history=1000
set lazyredraw                                    "only redraw when necessary
set encoding=utf-8
set laststatus=2                                  "always shows statusline / powerline
set noshowmode                                    "hides the mode for default statusline
set nowrap                                        "no word wrapping
set undofile                                      "allow per file undo persistance
set undoreload=10000
set undodir=~/.vim/tmp/undo//                     "undo dir
set backupdir=~/.vim/tmp/backups//                "backup dir -- // saves full filepath with % as folder delimeter
set directory=~/.vim/tmp/swap//                   "temporary dir for swap files
set backup                                        "file backups enabled
set writebackup                                   "enabling backups
set noswapfile                                    "disable swaps - were using backups in 2015
set noerrorbells                                  "kill the noise
set timeoutlen=350                                "delay for accepting key combination
set mousehide                                     "hide mouse while editing
set pastetoggle=<F2>                              "when in insert mode, allow easy external clipboard pasting
set incsearch                                     "search as characters are entered
set hlsearch                                      "highlight matches
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮  "show unicode characters for tab,eol,and with wrap on

"set leader key -- originally \ -- now localleader
let mapleader = ","
let maplocalleader = "\\"

"fold methods
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=12
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

"custom key commands and plugin settings
"Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z
"toggle nerdtree display
map <C-n> <plug>NERDTreeTabsToggle<CR>
"show/hide tagbar
nmap <F3> :TagbarToggle<CR>
"syntastic window
nmap <F4> :lwindow<CR>
"hide search highlighting
nnoremap <leader><space> :nohlsearch<CR> 
"display vim undo tree
nnoremap <leader>u :GundoToggle<CR>
"split line similar to using J to join a line
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

"ctrlp settings
let g:ctrlp_match_window = 'bottom,order:ttb'                     "order matches top to bottom
let g:ctrlp_switch_buffer = 0                                     "always open new file in new buffer
let g:ctrlp_working_path_mode = 0                                 "ctrlp respect dir change in vim session
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'    "allow ctrl p to use ag and be fast

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

if has('gui_running')
  if has('macunix')
    set guifont=Inconsolata\ for\ Powerline:h11     "set fonts for gui vim
  elseif has("gui_gtk2")                           "per vim wiki set gui font for most WMs
    set guifont=Inconsolata\ 10
  elseif has("gui_photon")
    set guifont=Inconsolata:s10
  elseif has("gui_kde")
    set guifont=Inconsolata/10/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-inconsolata-medium-r-normal-*-*-180-*-*-m-*-*
  else
    set guifont=Inconsolata:h10:cDEFAULT
  endif
  set guioptions-=egmt                            "hide the gui elements
  set guioptions-=T
  set guioptions-=m
  set guioptions-=L                               "odd fix for to get scrollbars 
  set guioptions-=r                               "properly hidden on left and right
  set background=dark
  colorscheme zenburn
endif

"syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
  "end recommended syntastic
let g:syntastic_loc_list_height = 6

let g:syntastic_javascript_checkers = ['jshint']

" javascript folding http://amix.dk/blog/post/19132
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

" fix so powerline updates faster 
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif
