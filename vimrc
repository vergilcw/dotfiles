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
Plug 'christoomey/vim-tmux-navigator'
Plug 'melonmanchan/vim-tmux-resizer'
"Plug 'jalvesaq/Nvim-R'
call plug#end()
