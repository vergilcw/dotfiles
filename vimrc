set showcmd "show when a command key is pressed/active
let maplocalleader = "\"
let mapleader = ","

"navigating buffers made easier: <leader>+l
nnoremap <leader>l :ls<CR>:b<space>

"This auto-installs vim-plug in case it's not already loaded:
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'   "better tmux bindings
Plug 'melonmanchan/vim-tmux-resizer'    "better tmux bindings

Plug 'jpalardy/vim-slime'             "connect to a REPL
"Plug 'jalvesaq/Nvim-R'
call plug#end()

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}
xmap <c-c><c-c> <Plug>SlimeRegionSend
nmap <c-c><c-c> <Plug>SlimeParagraphSend
nmap <c-c>v     <Plug>SlimeConfig
