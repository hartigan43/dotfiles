" .vimrc
" many things from http://bitbucket.org/sjl/dotfiles/src/tip/vim/

filetype off                   " required!
set nocompatible               " be iMproved

" Vim-plug ----------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged') "load vim-plug

Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fatih/vim-go'
"Plug  'FredKSchott/CoVim'
Plug 'jistr/vim-nerdtree-tabs'
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

" }}}

filetype plugin indent on
"filetype indent on

" Basic options ------------------------------------------------------------ {{{

syntax enable
set number                                        "show line numbers
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
"set noerrorbells                                 "kill the noise
set visualbell                                    "kill the noise
set timeoutlen=350                                "delay for accepting key combination
set mousehide                                     "hide mouse while editing
set pastetoggle=<F2>                              "when in insert mode, allow easy external clipboard pasting
set incsearch                                     "search as characters are entered
set ignorecase                                    "ignore case while searching
set smartcase                                     "ignores lower case if search pattern is uppercase
set hlsearch                                      "highlight matches
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮  "show unicode characters for tab,eol,and with wrap on
"set showbreak=↪

" set leader key -- originally \ -- now localleader
let mapleader = ","
let maplocalleader = "\\"

set runtimepath^=~/.vim/bundle/ctrlp.vim

" disable arrow keys / ctrl + hjkl window swap
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" if undo and backup directories do not exist, make them
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}
" Folding ------------------------------------------------------------------ {{{

set foldlevelstart=0

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}

set foldtext=MyFoldText()
set foldmethod=marker

" }}}
" Plugin-settings ---------------------------------------------------------- {{{
" ctrlp settings  ---------------------------------------------------------- {{{
let g:ctrlp_match_window = 'bottom,order:ttb'                     "order matches top to bottom
let g:ctrlp_switch_buffer = 0                                     "always open new file in new buffer
let g:ctrlp_working_path_mode = 0                                 "ctrlp respect dir change in vim session
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'    "allow ctrl p to use ag and be fast
" }}}

" gundo.vim settings ------------------------------------------------------- {{{
let g:gundo_width = 60
let g:gundo_preview_height = 40
" }}}

" syntastic settings ------------------------------------------------------- {{{
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
" }}}
"

"nerdtree shown on file open
let g:nerdtree_tabs_open_on_console_startup=1

"enable powerline symbols with airline
let g:airline_powerline_fonts = 1
" }}}
" Custom keys -------------------------------------------------------------- {{{
" Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" toggle nerdtree display
map <C-n> <plug>NERDTreeTabsToggle<CR>

" show/hide tagbar
nmap <F3> :TagbarToggle<CR>

" syntastic window
nmap <F4> :lwindow<CR>

" hide search highlighting
nnoremap <leader><space> :nohlsearch<CR> 

" display vim undo tree
nnoremap <leader>u :GundoToggle<CR>

" split line similar to using J to join a line
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" disable help key
noremap  <F1> :checktime<cr>
inoremap <F1> <esc>:checktime<cr>

" }}}
" GUI-settings ------------------------------------------------------------- {{{
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
" }}}
" Misc settings ------------------------------------------------------------ {{{
" javascript folding http://amix.dk/blog/post/19132
" function! JavaScriptFold()
"   setl foldmethod=syntax
"   setl foldlevelstart=1
"   syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
" 
"   function! FoldText()
"     return substitute(getline(v:foldstart), '{.*', '{...}', '')
"   endfunction
"   setl foldtext=FoldText()
" endfunction
" au FileType javascript call JavaScriptFold()
" au FileType javascript setl fen

" fix so powerline updates faster 
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif
" }}}
