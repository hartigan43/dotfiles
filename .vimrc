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
<<<<<<< HEAD
"Plug 'airblade/vim-rooter'
"Plug 'amadeus/vim-mjml',                { 'for': 'mljl' }
=======
Plug 'amadeus/vim-mjml',                { 'for': 'mjml' }
>>>>>>> fa49b754901cfac0acc51eb1c9bae9a26a6b4178
Plug 'christoomey/vim-tmux-navigator'
Plug 'codota/tabnine-vim'
Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
<<<<<<< HEAD
"Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries' }
"Plug 'honza/vim-snippets'
"Plug 'iamcco/markdown-preview.vim',     {'for': ['md', 'markdown'] }
=======
Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim',    { 'do': 'cd app & yarn install', 'for': ['md', 'markdown'] }
>>>>>>> fa49b754901cfac0acc51eb1c9bae9a26a6b4178
Plug 'itchyny/lightline.vim'
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'jparise/vim-graphql',             { 'for': ['graphql', 'graphqls', 'gql'] }
Plug 'junegunn/fzf',                    { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'junegunn/vim-peekaboo'
"Plug 'junegunn/rainbow_parentheses.vim'
Plug 'liuchengxu/vista.vim'
Plug 'mgee/lightline-bufferline'
Plug 'mileszs/ack.vim'
Plug 'othree/javascript-libraries-syntax.vim'
"Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree',             { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
"Plug 'SirVer/ultisnips'
Plug 'simnalamburt/vim-mundo',          { 'on': 'MundoToggle' }
Plug 'takac/vim-commandcaps'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-rails',                 { 'for': 'rb' }
"Plug 'tpope/vim-haml',                  { 'for': 'haml' }
Plug 'tpope/vim-surround'

" all the JS things
Plug 'yuezk/vim-js' | Plug 'HerringtonDarkholme/yats.vim' | Plug 'posva/vim-vue' | Plug 'maxmellon/vim-jsx-pretty'

"TODO TEST greyscale life
"Plug 'Lokaltog/vim-monotone'
"Plug 'fxn/vim-monochrome'
"ENDTEST

<<<<<<< HEAD
" https://github.com/junegunn/dotfiles/blob/master/vimrc
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !python3 ./install.py --clang-completer --go-completer --ts-completer --rust-completer
  endif
endfunction

"Plug 'ycm-core/YouCompleteMe',          { 'do': function('BuildYCM') }

=======
>>>>>>> fa49b754901cfac0acc51eb1c9bae9a26a6b4178
" note taking and writing
" Plug 'rhysd/vim-grammarous',            { 'for': ['text', 'markdown'] }
" Plug 'beloglazov/vim-online-thesaurus', { 'for': ['text', 'markdown'] }

" deoplete and tabnine
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

" gvim specific plugins
if has('gui_running')
"  Plug 'junegunn/seoul256.vim'
  Plug 'morhetz/gruvbox'
endif

call plug#end()
" }}}

" Basic options ------------------------------------------------------------ {{{
set number                                        "show line numbers
"set background=light                              "nvim 0.3.3 got weird and required this with dark gruvbox term settings, fixed with dim colorscheme?
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
colorscheme dim

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

"hacky python autocmd
autocmd Filetype python setlocal ts=4 softtabstop=4 shiftwidth=4

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
let g:ale_completion_delay = 250                                    "delay before ale completion, def 100
let g:ale_lint_delay = 550                                          "delay before ale linting`, def 200

let g:ale_linters = {
\ 'cpp': ['clang'],
\ 'go': ['gofmt', 'golint'],
\ 'javascript': ['prettier', 'eslint'],
\ 'python': ['flake8', 'pylint'],
\}

let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'css': ['prettier'],
\ 'go': ['gofmt'],
\ 'javascript': ['prettier', 'eslint'],
\ 'python': ['autopep8', 'isort'],
\}

let g:ale_javascript_prettier_options = '--single-quote --trailing-comma --no-unused-vars --no-mixed-spaces-and-tabs'
let g:ale_cpp_clang_executable = 'clang++'
let g:ale_cpp_clang_options = '-stdc=c++14 -Wall `sdl2-config --cflags --libs`'

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
" }}}

" deoplete settings ------------------------------------------------------- {{{
let g:deoplete#enable_at_startup = 1
" }}}

" fzf settings  ---------------------------------------------------------- {{{
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nnoremap <C-P> :Files <CR>
nnoremap <leader>p :Rg <CR>

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

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
	\    'lineinfo': '%3l:%-2v',
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
	\   'left': ' ', 'right': ' '
  \}
let g:lightline.subseparator = {
<<<<<<< HEAD
	\   'left': ' ', 'right': ' ' 
=======
	\   'left': '', 'right': ''
>>>>>>> fa49b754901cfac0acc51eb1c9bae9a26a6b4178
  \}
let g:lightline.tabline = {
  \   'left': [ ['buffers'] ],
  \   'right': [[]],
  \}
let g:lightline.tabline_separator = {
  \   'left': '', 'right': '|'
  \}
let g:lightline.tabline_subseparator = {
  \   'left': '', 'right': '|'
  \}
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
let g:mkdp_browser = "/usr/bin/firefox"
let g:mkdp_port = "8522"
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

" Vista Settings  ------------------------------------------------------- {{{
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 0
autocmd bufenter * if (winnr("$") == 1 && vista#sidebar#IsOpen()) | q | endif
" }}}

" Keymaps -------------------------------------------------------------- {{{
" Clean trailing whitespace
nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" toggle nerdtree display
noremap <F4> :NERDTreeToggle<CR>

" show/hide tagbar/vista
"nmap <F3> :TagbarToggle<CR>
nmap <F3> :Vista!!<CR>

" hide search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" display vim undo tree
nnoremap <leader>u :MundoToggle<CR>

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
