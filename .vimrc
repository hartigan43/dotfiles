set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
"Desktop
"set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim
set runtimepath^=~/.vim/bundle/ctrlp.vim
call vundle#rc()

"LAPTOP - powerline - pip2.7
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

"let Vundle manage Vundle
"required! 
Bundle 'gmarik/vundle'
"chosen vim extensions
Bundle 'altercation/vim-colors-solarized'
Bundle 'airblade/vim-gitgutter'
"Bundle 'FredKSchott/CoVim'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'majutsushi/tagbar'
Bundle 'pangloss/vim-javascript'
Bundle 'prendradjaja/vim-vertigo'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'takac/vim-commandcaps'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-surround'
"Bundle 'Valloric/YouCompleteMe'

filetype plugin indent on "req

"nerdtree shown on file open
let g:nerdtree_tabs_open_on_console_startup=1
"easy motion leader key setting
"let g:EasyMotion_leader_key = '''

syntax enable
"set term=screen-256color
set t_Co=256 
"colorscheme solarized
set number                    "show line numbers
set background=light
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
let g:syntastic_javascript_checkers = ['jslint']

" vertigo navigation bindings
nnoremap <silent> <Space>j :<C-U>VertigoDown n<CR>
vnoremap <silent> <Space>j :<C-U>VertigoDown v<CR>
onoremap <silent> <Space>j :<C-U>VertigoDown o<CR>
nnoremap <silent> <Space>k :<C-U>VertigoUp n<CR>
vnoremap <silent> <Space>k :<C-U>VertigoUp v<CR>
onoremap <silent> <Space>k :<C-U>VertigoUp o<CR>

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
