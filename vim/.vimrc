" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible
" Automatically refresh currently opened file/s when the file/s have been 
" changed outside of vim
set autoread
" Copy/Paste/Cut using system clipboard
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

"========== Plugins ==========" 
" Automatic installation of vim-plug if it's not yet installed
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
" NOTE: The installation won't work if the curl package is not installed
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" NOTE: This line below is not given in the link above but it's required
" or an error will appear on execution (PlugInstall is dependent on it)
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'

" vim must have the popupwin feature for these to work properly
if has('nvim-0.4.0') || has('patch-8.2.191')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'  
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  " vim must have the :terminal command for this to work properly
  if exists(':terminal')
	Plug 'chengzeyi/multiterm.vim'
  endif
endif

" The master branch is async-only and thus requires at least Vim 8.0.902.
" Use the legacy branch for older Vim versions.
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

call plug#end()

"========== User Interface =========="
" Use the gruvbox plugin as our colorscheme (in dark mode)
colorscheme gruvbox
set background=dark
" Show (partial) commands in status line
set showcmd
" Turn on syntax highlighting.
syntax on
" Better command-line completion
set wildmenu
" Disable the default Vim startup message.
set shortmess+=I
" Show line numbers.
set number
" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber
" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
" Disable audible/visual bell because it's annoying.
set noerrorbells visualbell t_vb=
" Adds a vertical line on the 80th column for visual reference.
set colorcolumn=80
highlight ColorColumn ctermbg=238
" Use terminal background
highlight Normal ctermbg=NONE
" Leaves 8 lines of code as an allowance while scrolling up/down
set scrolloff=8
" Prevent line wrapping 
set nowrap
" Put vertical window splits to the right
set splitright
" Show row and column number of cursor position
set ruler

"==========  Tabs and Indentation =========="
" Number of visual spaces per TAB
set tabstop=4
" Number of spaces in TAB when editing
set softtabstop=4
" Number of spaces indented when reindent operations (>> and <<) are used
set shiftwidth=4
" Convert TABs to spaces
set expandtab
" Enable intelligent tabbing and spacing for indentation and alignment
set smarttab
" When opening a new line and no file-specific indenting is enabled,
" keep same indent as the line you're currently on
set autoindent

"========== Searching =========="
" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase
" Enable searching as you type, rather than waiting till you press enter.
set incsearch

"========== General Mapping =========="
" This will make Y behave like D/C
nnoremap Y y$

"========== General Leader Mappings =========="
" Set leader key to spacebar
let mapleader = " "
" Resize windows easily
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

"========== Movement =========="
" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start
" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a
" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
" Switch between window splits easily
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>
" Move text up and down easily then apply the correct indentation
" Do this in normal mode...
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
" ...and in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"========== Modes =========="
" 'Q' in normal mode enters Ex mode. You almost never want this.
nnoremap Q <Nop> 
" This will make exiting insert mode to normal mode more efficiently.
inoremap jk <ESC>
inoremap kj <ESC>

"========== netrw =========="
" Instantiate netrw explorer window easily
nnoremap <leader>pv :Lex<CR>
" Remove the netrw mapping of <C-l> to refresh. This is so that our map of
" <C-l> to move to the right window split will still work on netrw
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END
function! NetrwMapping()
    nnoremap <buffer> <C-l> :wincmd l<CR>
endfunction
" Remove the netrw banner at the top
let g:netrw_banner=0
" Make netrw list the directories as trees
let g:netrw_liststyle=3
" Instantiate netrw window with proper window size
let g:netrw_winsize=25

"========== fzf =========="
" Open fzf as a pop-up window in the center
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
" Open fzf file searching window easily
nnoremap <C-p> :Files<CR>
" Open fzf ripgrep searching window easily
nnoremap <C-g> :Rg<CR>
" Re-map horizontal window split file opening to <C-s> for consistency
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
" Better fuzzy searching using ripgrep (but only if ripgrep is installed)
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
endif

"========== coc.nvim =========="
" Automatically install coc extensions if missing
let g:coc_global_extensions = ['coc-pyright']
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <C-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <C-space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif
" Make <CR> select the first completion item and confirm the completion when
" no item has been selected
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

"========== multiterm =========="
" Put the following lines in your configuration file to map <F12> to use Multiterm
nmap <F12> <Plug>(Multiterm)
" In terminal mode `count` is impossible to press, but you can still use <F12>
" to close the current floating terminal window without specifying its tag
tmap <F12> <Plug>(Multiterm)

"========== Pending =========="
" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
" set hidden
"
" This currently makes it hard to navigate with vim-signify. So this is
" disabled for now.
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" if has("nvim-0.5.0") || has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif
"
" For coc.nvim:
" Make <CR> confirm completion, only when there's selected complete item
" if exists('*complete_info')
"   inoremap <silent><expr> <CR> complete_info(['selected'])['selected'] != -1 ? "\<C-y>" : "\<C-g>u\<CR>"
" endif

