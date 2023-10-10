"" .vimrc
" TODO fix vim-lsp and get install check for treesitter for
" go,cpp,javascript,yaml,json,bash,rust,ssh_config,python,regex,terraform
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
Plug 'amadeus/vim-mjml',                { 'for': 'mjml' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go',                    { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'hashivim/vim-terraform',          { 'for': 'tf' }
Plug 'honza/vim-snippets'
Plug 'lambdalisue/fern.vim',            { 'on': 'Fern' }
Plug 'itchyny/lightline.vim'
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'jparise/vim-graphql',             { 'for': ['graphql', 'graphqls', 'gql'] }
Plug 'junegunn/fzf',                    { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'liuchengxu/vista.vim'
Plug 'maximbaz/lightline-ale'
Plug 'mgee/lightline-bufferline'
Plug 'mileszs/ack.vim'
"Plug 'neovim/nvim-lspconfig'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'puremourning/vimspector'
"Plug 'ryanoasis/vim-devicons'
Plug 'SirVer/ultisnips'
Plug 'simnalamburt/vim-mundo',          { 'on': 'MundoToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rails',                 { 'for': 'rb' }
Plug 'tpope/vim-haml',                  { 'for': 'haml' }
Plug 'tpope/vim-surround'

" all the JS things
Plug 'yuezk/vim-js' | Plug 'HerringtonDarkholme/yats.vim' | Plug 'posva/vim-vue' | Plug 'maxmellon/vim-jsx-pretty'

" note taking and writing
Plug 'rhysd/vim-grammarous',            { 'for': ['text', 'markdown'] }
Plug 'beloglazov/vim-online-thesaurus', { 'for': ['text', 'markdown'] }

" nvim specific
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

" plugins that require deno
if executable('deno')
  """ ddc
  Plug 'Shougo/ddc.vim'
  Plug 'vim-denops/denops.vim'

  " Install your UIs
  Plug 'Shougo/ddc-ui-native'

  " ddc sources
  Plug 'delphinus/ddc-tmux'
  Plug 'delphinus/ddc-treesitter'
  Plug 'LumaKernel/ddc-source-file'
  Plug 'matsui54/ddc-buffer'
  Plug 'Shougo/ddc-around'
"  Plug 'Shougo/ddc-source-nvim-lsp'
  Plug 'Shougo/ddc-source-rg'
  Plug 'tani/ddc-path'
  Plug 'statiolake/ddc-ale'
"  Plug 'uga-rosa/ddc-nvim-lsp-setup'

  " ddc filters and matchers
  Plug 'Shougo/ddc-filter-matcher_head'
  Plug 'tani/ddc-fuzzy'
  "Plug 'Shougo/ddc-sorter_rank'
  """" end ddc

  "deno and nvim
  if has('nvim')
    Plug 'toppair/peek.nvim',  { 'do': 'deno task --quiet build:fast', 'for': ['md', 'markdown'] }
  endif
else "alternatives when on a machine without deno
  echo "deno not found in path, using fallback completion"
  if has('nvim')
    " deoplete and tabnine
    Plug 'nvim-lua/plenary.nvim' | Plug 'NTBBloodbath/rest.nvim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'editorconfig/editorconfig-vim' "editorconfig native in nvim
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'Shougo/deoplete.nvim'
  endif
endif

" gui specific plugins
if has('gui_running')
  Plug 'morhetz/gruvbox' " 'junegunn/seoul256.vim'
endif

call plug#end()
" }}}

" Basic options ------------------------------------------------------------ {{{
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
set tgc

if $EDITOR_MONOTONE == "true"
  "let base16colorspace=256
  set background=light
  colorscheme komau-mod
  "colorscheme grim
  "let g:monotone_color = [170, 0,25]
  "let g:monotone_contrast_factor = -0.75
  "let g:monotone_emphasize_comments = 0 " Emphasize comments
  "colorscheme monotone
  highlight Comment cterm=italic gui=italic
else
  colorscheme dim
endif

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
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'            "define the format of the messages
let g:ale_completion_delay = 250                                    "delay before ale completion, def 100
let g:ale_lint_delay = 550                                          "delay before ale linting`, def 200

let g:ale_linters = {
\ 'cpp': ['clang'],
\ 'go': ['gofmt', 'golint'],
\ 'javascript': ['eslint'],
\ 'python': ['ruff', 'flake8'],
\ 'terraform': ['terraform'],
\}

let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'css': ['prettier'],
\ 'go': ['gofmt'],
\ 'javascript': ['eslint'],
\ 'python': ['black'],
\ 'terraform': ['terraform'],
\}

let g:ale_c_parse_makefile = 1
let g:ale_cpp_clang_executable = 'clang++'
let g:ale_cpp_clang_options = '-stdc=c++14 -Wall `sdl2-config --cflags --libs`'
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma --no-unused-vars --no-mixed-spaces-and-tabs'
let g:ale_python_black_options = ''
let g:ale_python_flake8_options = '--max-line-length=88 --extend-ignore=E203'
let g:ale_python_ruff_options = ''

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" checks for an open preview window - SO14300101
function! CheckPreviewWindow()
  for nr in range(1, winnr('$'))
    if getwinvar(nr, "&pvw") == 1
            " found a preview
            return 1
        endif
    endfor
    return 0
endfunction

function! ToggleALEPreview()
  if CheckPreviewWindow()
    :pclose
  else
    :ALEDetail
  endif
endfunction
" }}}

" ddc.vim settings ------------------------------------------------------- {{{

"if denops#plugin#is_loaded('ddc')
"  local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
"  require("lspconfig").denols.setup({
"    capabilities = capabilities,
"  })
"endif
"sourceOption
"    \ 'nvim-lsp': {
"    \     'mark': 'LSP',
"    \     'forceCompletionPattern': '\.\w*|:\w*|->\w*',
"    \   },
"sourceParam
"    \ 'nvim-lsp': {
"    \   'snippetEngine': denops#callback#register({
"    \         body -> vsnip#anonymous(body)
"    \   }),
"    \   'enableResolveItem': v:true,
"    \   'enableAdditionalTextEdit': v:true,
"    \ },

" ui must be set -- native: https://github.com/Shougo/ddc-ui-native
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', ['ale','around','buffer','file','path','rg','tmux','treesitter']) "nvim-lsp
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
    \   'matchers': ['matcher_fuzzy', 'matcher_head'],
    \   'sorters': ['sorter_fuzzy'],
    \   'converters': ['converter_fuzzy']
    \ },
    \ 'ale': {
    \   'mark': 'ALE',
    \   'maxItems': 3,
    \ },
    \ 'around': {
    \   'mark': 'ARO',
    \   'maxItems': 5,
    \ },
    \ 'buffer': {
    \   'mark': 'BUF',
    \   'maxItems': 3,
    \ },
    \ 'file': {
    \   'mark': 'FILE',
    \   'isVolatile': v:true,
    \   'forceCompletionPattern': '\S/\S*',
    \   'maxItems': 3,
    \ },
    \ 'path': {
    \   'mark': 'PATH',
    \   'maxItems': 3,
    \ },
    \ 'rg': {
    \   'mark': 'RG',
    \   'minAutoCompleteLength': 4,
    \   'maxItems': 4,
    \ },
    \ 'tmux': {
    \   'mark' : 'TMUX',
    \   'maxItems': 2,
    \ },
    \ 'treesitter': {
    \   'mark': 'TREE',
    \   'maxItems': 5,
    \ },
    \})

call ddc#custom#patch_global('sourceParams', {
    \ 'ale': {
    \   'cleanResultsWhitespace': v:false,
    \ },
    \ 'around': {
    \   'maxCandidates': 3,
    \ },
    \ 'buffer': {
    \   'requireSameFiletype': v:false,
    \   'limitBytes': 5000000,
    \   'fromAltBuf': v:true,
    \   'forceCollect': v:true,
    \ },
    \})

call ddc#custom#patch_filetype(
    \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
    \   'file': {
    \     'forceCompletionPattern': '\S\\\S*',
    \   },
    \ },
    \ 'sourceParams': {
    \   'file': {
    \     'mode': 'win32',
    \   },
    \ }})

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

call ddc#enable()
" }}}

" deoplete settings ------------------------------------------------------- {{{
if 'g:loaded_deoplete'->exists()
  echo "hi"
  let g:deoplete#enable_at_startup = 1
  " Use ALE and also some plugin 'foobar' as completion sources for all code.
  call deoplete#custom#option('sources', {
  \ '_': ['ale'],
  \})
endif
" }}}

" EditorConfig settings ------------------------------------------------------- {{{
" only load if using the plugin for vim, neovim has native support
if 'let g:loaded_EditorConfig = 1'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
  au FileType gitcommit let b:EditorConfig_disable = 1
endif
" }}}

" fern settings  ---------------------------------------------------------- {{{
let g:fern#renderer#default#leading = "│"
let g:fern#renderer#default#root_symbol = "┬ "
let g:fern#renderer#default#leaf_symbol = "├─ "
let g:fern#renderer#default#collapsed_symbol = "├─ "
let g:fern#renderer#default#expanded_symbol = "├┬ "

function! s:fern_init() abort
  " Find and enter project root
  nnoremap <buffer><silent>
        \ <Plug>(fern-my-enter-project-root)
        \ :<C-u>call fern#helper#call(funcref('<SID>map_enter_project_root'))<CR>
  nmap <buffer><expr><silent>
        \ ^
        \ fern#smart#scheme(
        \   "^",
        \   {
        \     'file': "\<Plug>(fern-my-enter-project-root)",
        \   }
        \ )
endfunction

function! s:map_enter_project_root(helper) abort
  " NOTE: require 'file' scheme
  let root = a:helper.get_root_node()
  let path = root._path
  let path = finddir('.git/..', path . ';')
  execute printf('Fern %s', fnameescape(path))
endfunction
" }}}


" fzf settings  ---------------------------------------------------------- {{{
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nnoremap <C-P> :Files <CR>
nnoremap <leader>p :Rg <CR>
nnoremap <leader>[ :Snippets <CR>

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

function LightlineFugitiveHead()
  let head = FugitiveHead()
  if head != ""
    let head = "\uf126 " .. head
  endif
  return head
endfunction

let g:lightline = {
  \  'colorscheme': 'seoul256',
  \  'active': {
  \    'left':[ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename' ]
  \    ],
  \    'right':[ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
  \              [ 'lineinfo' ],
	\              [ 'percent' ],
	\              [ 'fileformat', 'fileencoding', 'filetype']
  \   ]
  \  },
	\  'component': {
	\    'lineinfo': ' %3l:%-2v',
	\  },
  \  'component_function': {
  \    'gitbranch': 'LightlineFugitiveHead',
  \    'filename': 'LightlineFilename',
  \  },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_infos': 'lightline#ale#infos',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok',
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

" remove the divider between filename and modified which is added by default lightline
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" lightline-bufferline settings
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline#bufferline#enable_devicons = 1

" unicode icons for lightline-ale
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

"enable the bufferline with lightline+lightline-bufferline
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline
" }}}

" Markdown Preview settings --------------------------------------------------- {{{
let g:mkdp_browser = "/usr/bin/firefox"
let g:mkdp_port = "8522"
" }}}

"  netrw settings --------------------------------------------------- {{{
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 0
let g:netrw_winsize = 12
" }}}

" UltiSnips settings ------------------------------------------------------- {{{
let g:UltiSnipsExpandTrigger="<c-;>"
let g:UltiSnipsListSnippets="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "custom-snips"]

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
"noremap <F4> :Vex<CR>
noremap <F4> :Fern . -reveal=% -drawer -stay<CR>

" show/hide tagbar/vista
nmap <F3> :Vista!!<CR>

nmap <F5> :call ToggleALEPreview()<CR>

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
nnoremap <leader>a :Ack!<Space><C-R><C-W>

"use leader e or leader s to open or vsplit with filename in current directory
"leader E,S uses parent directory
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>E :e <C-R>=expand("%:p:h:h") . "/" <CR>
nnoremap <leader>s :vsplit <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>S :vsplit <C-R>=expand("%:p:h:h") . "/" <CR>

"underline the current line - mostly for taking notes until I start using
"something with cloud support
nnoremap <leader><F5> yyp<c-v>$r-

"yank the whole file to clipboard
nmap <leader>y :%y+<cr>

"vimspector
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver
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
"
