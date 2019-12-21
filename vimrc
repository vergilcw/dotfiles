set number "show line numbers
set numberwidth=3
set number relativenumber "enabling both rel and absolute gives hybrid

set tabstop=2 shiftwidth=2 expandtab "tabs as spaces

"navigate through soft wrap lines with j and k while preserving relative
"numbering navigation.
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

"Make Ctrl-Shift-j/k move lines up or down.
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

augroup numbertoggle "turn off relative line numbers in insert mode
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


set showcmd "show when a command key is pressed/active

"remap the localleader and leader to easy keys
let maplocalleader = '\\'
let mapleader = ','

"navigating buffers made easier: <leader>+l
nnoremap <leader>l :ls<CR>:b<space>


""" VIM PLUG PLUGINS AND CONFIG
"This auto-installs vim-plug in case it's not already loaded:
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

"load plugins
call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'   "better tmux bindings
Plug 'melonmanchan/vim-tmux-resizer'    "better tmux bindings
Plug 'jpalardy/vim-slime'               "connect to a REPL
Plug 'chriskempson/base16-vim'          "16-bit vim colors (for compatibility)
call plug#end()

"settings for REPL to send-code via vim-slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{top-right}"}
"Map hotkey to run code as Ctrl-/ (synonym for Ctrl-_)
xmap <c-_> <Plug>SlimeRegionSend 
let g:slime_dont_ask_default = 1
nmap <c-_> <Plug>SlimeLineSend
nmap <c-c>v     <Plug>SlimeConfig

"colorscheme base16-default-dark
