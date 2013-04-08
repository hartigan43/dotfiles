set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim
set runtimepath^=~/.vim/bundle/ctrlp.vim
call vundle#rc()

"let Vundle manage Vundle
"required! 
Bundle 'gmarik/vundle'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-surround'
Bundle 'Valloric/YouCompleteMe'

filetype plugin indent on "req

"colorscheme base16-tomorrow
let g:nerdtree_tabs_open_on_console_startup=1

syntax enable
set term=screen-256color
set number                    "show line numbers
set background=dark
set ts=2                      "tabs width as two spaces
set shiftwidth=2              
set autoindent                "keep indentation of current line
set smarttab
set expandtab                 "converts tabs to spaces
set showmatch
set encoding=utf-8
set laststatus=2              "always shows statusline / powerline
set noshowmode                "hides the mode for default statusline
set nowrap                    "no word wrapping
set backup                    "file backups enabled
set backupdir=~/.vim/backups  "backup dir
set directory=~/.vim/tmp      "temporary dir
set noerrorbells              "kill the noise
set timeoutlen=350            "delay for accepting key combination
set mousehide                 "hide mouse while editing
set pastetoggle=<F2>          "when in insert mode, allow easy external clipboard pasting

"enable fold based on indent with max level of 10
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
map <C-n> <plug>NERDTreeTabsToggle<CR>
nmap <F3> :TagbarToggle<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

if has('gui_running')
  set guifont=Inconsolata\ for\ Powerline:h11     "set fonts for gui vim
  set guioptions-=egmt                            "hide the gui elements
  set guioptions-=L                               "odd fix for to get scrollbars 
  set guioptions-=r                               "properly hidden on left and right
  set background=dark
  colorscheme base16-solarized
endif

" addons for the tagbar vim plugin
let g:tagbar_phpctags_bin='~/.vim/plugin/tagbar-phpctags.vim'
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

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
