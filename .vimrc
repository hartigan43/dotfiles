"" .vimrc
" many things from http://bitbucket.org/sjl/dotfiles/src/tip/vim/

if !has('nvim')                " vim specific vs neovim below
  set nocompatible             " be iMproved

  " install Vim-plug if not installed
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

if has('nvim')
  set mouse-=a                 " not ready for mouse use yet

  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" Vim-plug ----------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged') "load vim-plug

Plug 'airblade/vim-gitgutter'
"Plug 'airblade/vim-rooter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries' }
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.vim',     {'for': ['md', 'markdown'] }
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf',                    { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'majutsushi/tagbar'
Plug 'mgee/lightline-bufferline'
Plug 'mileszs/ack.vim'
Plug 'mxw/vim-jsx',                     { 'for': ['jsx', 'javascript.jsx'] }
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'pangloss/vim-javascript'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree',             { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
"Plug 'shinchu/lightline-gruvbox.vim'
Plug 'SirVer/ultisnips'
Plug 'sjl/gundo.vim',                   { 'on': 'GundoToggle' }
Plug 'takac/vim-commandcaps'
"Plug 'ternjs/tern_for_vim',             { 'dir': '~/.vim/plugged/tern_for_vim', 'do': 'yarn install' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails',                 { 'for': 'rb' }
Plug 'tpope/vim-haml',                  { 'for': 'haml' }
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

"TODO TEST greyscale life
"Plug 'Lokaltog/vim-monotone'
"Plug 'fxn/vim-monochrome'
"ENDTEST

" https://github.com/junegunn/dotfiles/blob/master/vimrc
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --go-completer --ts-completer --rust-completer
  endif
endfunction

Plug 'Valloric/YouCompleteMe',          { 'do': function('BuildYCM') }

" note taking and writing
Plug 'rhysd/vim-grammarous',            { 'for': ['text', 'markdown'] }
Plug 'beloglazov/vim-online-thesaurus', { 'for': ['text', 'markdown'] }

" nvim specific plugins

" gvim specific plugins
if has('gui_running')
"  Plug 'junegunn/seoul256.vim'
  Plug 'morhetz/gruvbox'
endif

call plug#end()
" }}}

" Basic options ------------------------------------------------------------ {{{
set number                                        "show line numbers
set background=light                              "nvim 0.3.3 got weird and required this with dark gruvbox term settings
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
set noshowmode                                    "hides the mode for default statusline as its unnecessary with powerline/airline/lightline
set nowrap                                        "no word wrapping
set undofile                                      "allow per file undo persistance
set undoreload=10000
set undodir=~/.vim/tmp/undo//                     "undo dir
set backupdir=~/.vim/tmp/backups//                "backup dir -- // saves full filepath with % as folder delimeter
set directory=~/.vim/tmp/swap//                   "temporary dir for swap files
set backup                                        "file backups enabled
set writebackup                                   "enabling backups
set noswapfile                                    "disable swaps - were using backups
set visualbell                                    "kill the noise
set timeoutlen=350                                "delay for accepting key combination
set mousehide                                     "hide mouse while editing
set pastetoggle=<F2>                              "when in insert mode, allow easy external clipboard pasting
set incsearch                                     "search as characters are entered
set ignorecase                                    "ignore case while searching
set smartcase                                     "case insensitive search if capital letters are used
set hlsearch                                      "highlight matches
"set list!                                         "toggles list, default is off, enables whitespace characters
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮  "show unicode characters for tab,eol,and with wrap on
set showbreak=↪
set modeline
set modelines=2                                   "use modelines at end of file for specifc settings

" set leader key -- originally \ -- now localleader
let mapleader = ","
let maplocalleader = "\\"

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

"hide ugly code past 120 characters on a line
"from https://kinbiko.com/vim/my-shiniest-vim-gems/
autocmd Filetype if &ft!="txt,md" match ErrorMsg '\%>120v.\+' endif

" }}}
" Folding ------------------------------------------------------------------ {{{

set foldlevelstart=4
set foldmethod=syntax

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" }}}
" Plugin-settings ---------------------------------------------------------- {{{
 
" Ack settings  ---------------------------------------------------------- {{{
" TODO monitor usage, with fzf#vim#ag, unsure of total use of ack
if executable('ag')
  let &grepprg = 'ag --nogroup --nocolor --column'
  let g:ackprg = 'ag --vimgrep'
else
  let &grepprg = 'grep -rn $* *'
endif
" }}}
 
" ALE settings ------------------------------------------------------- {{{
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%][%severity%] %s'             "define the format of the messages
let g:airline#extensions#ale#enabled = 1                           "let ALE work within airline
let g:ale_completion_delay = 250                                    "delay before ale completion, def 100
let g:ale_lint_delay = 550                                          "delay before ale linting`, def 200

let g:ale_linters = {
\ 'javascript': ['prettier'],
\}

let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'css': ['prettier'],
\}

let g:ale_javascript_prettier_options = '--single-quote --trailing-comma --no-unused-vars --no-mixed-spaces-and-tabs'
" }}}

" Airline settings ------------------------------------------------------- {{{
"enable powerline symbols with airline
let g:airline_powerline_fonts = 1                                   

let g:airline#extensions#tabline#enabled = 1                        "enable tabline to show open buffers or tabs
let g:airline#extensions#tabline#left_sep = ' '                     "use ' | ' as separator instead of the normal powerline separators
let g:airline#extensions#tabline#left_alt_sep = '|'         
let g:airline#extensions#tabline#buffer_min_count = 2               "only show the tabline with at least two buffers open
" }}}
 
" fzf settings  ---------------------------------------------------------- {{{
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nnoremap <C-P> :FZF <CR>
nnoremap <leader>p :Rg <CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" revist  https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" }}}

" gundo.vim settings ------------------------------------------------------- {{{
let g:gundo_width = 60
let g:gundo_preview_height = 40
" }}}

" lightline.vim settings  ------------------------------------------------------- {{{
"  \  'colorscheme': 'gruvbox',
let g:lightline = {
  \  'active': {
  \    'left':[ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename' ]
  \    ]
  \  },
	\  'component': {
	\    'lineinfo': ' %3l:%-2v',
	\  },
  \  'component_function': {
  \    'gitbranch': 'fugitive#head',
  \    'filename': 'LightlineFilename',
  \  },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel',
  \ },
  \ }
let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': '' 
  \}
let g:lightline.tabline = {
  \   'left': [ ['buffers'] ],
  \   'right': [[]],
  \}
" TODO not possible?
"let g:lightline.tabline.separator = {
"  \   'left': '', 'right': '|'
"  \}
"
let s:palette = g:lightline#colorscheme#default#palette
"inactive text, inactive bg, active text, active background 
if has('nvim') "vim is very unhappy with color 236 at the moment, could nto find a quick fix for err 254
  let s:palette.tabline.tabsel = [ [ 3, 236, 253, 9 ] ]   "https://github.com/itchyny/lightline.vim/issues/207 might have clues to fix
endif
let s:palette.tabline.middle = s:palette.normal.middle
unlet s:palette

"remove the divider between filename and modified which is added by default lightline
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" lightline-bufferline settings
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline#bufferline#enable_devicons = 1

"enable the bufferline with lightline+lightline-bufferline
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline
" }}}

" Markdown Preview settings --------------------------------------------------- {{{
let g:mkdp_path_to_chrome = "/usr/bin/firefox"
" }}}

" NERDTree settings --------------------------------------------------- {{{
" close vim if NERDTree is the only thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" NERDCommenter settings --------------------------------------------------- {{{
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhiteSpace = 1
" }}}

" UltiSnips settings ------------------------------------------------------- {{{
let g:UltiSnipsExpandTrigger="<c-;>"
let g:UltiSnipsListSnippets="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

" YouCompleteMe settings ------------------------------------------------------- {{{
let g:ycm_min_num_of_chars_for_completion = 6               "default is 2, less results on smaller words/vars
let g:ycm_autoclose_preview_window_after_insertion = 1      "close preview window after insert is exited
                                                            "after a completion is used. consider after_completion
let g:ycm_complete_in_comments = 1                          "enable completion in comments
let g:ycm_collect_identifiers_from_comments_and_strings = 0 "collect identifiers from strings and comments
" }}}

let g:used_javascript_libs = 'angular,jquery'

" }}}
" Keymaps -------------------------------------------------------------- {{{
" Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" toggle nerdtree display
noremap <F4> :NERDTreeToggle<CR> 

" show/hide tagbar
nmap <F3> :TagbarToggle<CR>

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

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"do not have ack jump to first response
cnoreabbrev Ack Ack!
"ack for the current word under cursor
nnoremap <Leader>a :Ack!<Space><C-R><C-W>

"use leader e or leader s to open or vsplit with filename in current directory
"leade E,S uses parent directory
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>E :e <C-R>=expand("%:p:h:h") . "/" <CR>
nnoremap <leader>s :vsplit <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>S :vsplit <C-R>=expand("%:p:h:h") . "/" <CR>

"underlinethe current line - mostly for taking notes until I start using
"something with cloud support
nnoremap <leader><F5> yyp<c-v>$r-

"yank the whole file to clipboard
nmap <leader>y :%y+<cr>
" }}}

" File specific overrides -------------------------------------------------- {{{
autocmd BufNewFile,BufRead *.html.twig   set syntax=html
augroup WrapLineForTextFiles
  autocmd!
  autocmd FileType md,markdown setlocal wrap spell spelllang=en_us
  autocmd FileType txt,text setlocal wrap spell spelllang=en_us
augroup END
" }}}

" GUI-settings ------------------------------------------------------------- {{{
if has('gui_running')
  if has('macunix')
    set guifont=Inconsolata\ for\ Powerline:h11     "set fonts for gui vim
  elseif has("gui_gtk2")                           "per vim wiki set gui font for most WMs
    set guifont=Inconsolata\ 11
  elseif has("gui_photon")
    set guifont=Inconsolata:s11
  elseif has("gui_kde")
    set guifont=Inconsolata/11/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-inconsolata-medium-r-normal-*-*-180-*-*-m-*-*
  else
    set guifont=Inconsolata:h10:cDEFAULT
  endif
  set guioptions-=egmt                            "hide the gui elements
  set guioptions-=T
  set guioptions-=m
  set guioptions-=L                               "oddly, only way to get scrollbars 
  set guioptions-=r                               "properly hidden on left and right
  set background=dark
  colorscheme gruvbox                             "or seoul256
  set noerrorbells                                "stop flashing screen
  set novisualbell
endif
" }}}

" Misc settings ------------------------------------------------------------ {{{
" once contained powerline specific fix.. now barren
" }}}

"vim:foldmethod=marker:foldlevel=0:
