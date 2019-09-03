set number "show line numbers
set numberwidth=3
set number relativenumber "enabling both rel and absolute gives hybrid

augroup numbertoggle "turn off relative line numbers in insert mode
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


set showcmd "show when a command key is pressed/active
let maplocalleader = ","

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
"Map hotkey to run code as Ctrl-/ (synonym for Ctrl-_)
xmap <c-_> <Plug>SlimeRegionSend 
let g:slime_dont_ask_default = 1
nmap <c-_> <Plug>SlimeLineSend
nmap <c-c>v     <Plug>SlimeConfig

