set number "show line numbers
set showcmd "show when e.g. the leader key is pressed
set numberwidth=3
set number relativenumber "enabling both rel and absolute gives hybrid
set textwidth=80
"set colorcolumn=81,161,241,321,401,481,561,641,721,801 "show up to 10 wrapped lines, first col highlighted
set formatoptions+=t
" run :set list to see special chars
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

set esckeys

set tabstop=2 shiftwidth=2 expandtab "tabs as spaces

"navigate through soft wrap lines with j and k while preserving relative
"numbering navigation.
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

"Make Ctrl-Shift-j/k move lines up or down. (Not currently working, it only
"switches tmux panes

"nnoremap <C-S-j> :m .+1<CR>==
"nnoremap <C-S-k> :m .-2<CR>==
"inoremap <C-S-j> <Esc>:m .+1<CR>==gi
"inoremap <C-S-k> <Esc>:m .-2<CR>==gi
"vnoremap <C-S-j> :m '>+1<CR>gv=gv
"vnoremap <C-S-k> :m '<-2<CR>gv=gv

augroup numbertoggle "turn off relative line numbers in insert mode
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"in visual mode, control+R then <search term> then <enter> for find/replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>


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
Plug 'github/copilot.vim'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'   "better tmux bindings
Plug 'RyanMillerC/better-vim-tmux-resizer' "improved resizing vs. vim-tmux-resizer
Plug 'ojroques/vim-oscyank'             "copy to system clipboard
Plug 'zweifisch/replit.vim' "send lines to other pane (simpler than vim-slime)
call plug#end()
"Plug 'jpalardy/vim-slime'               "connect to a REPL
"Plug 'altercation/vim-colors-solarized' "solarized colorscheme
"Plug 'chriskempson/base16-vim'          "16-bit vim colors (for compatibility)

"for vim-oscyank plugin, always yank to chromeos system clipboard
"autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif



" Cursor in terminal
" https://vim.fandom.com/wiki/Configuring_the_cursor
" 1 or 0 -> blinking block
" 2 solid block
" 3 -> blinking underscore
" 4 solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
  
if &term =~ '^xterm'
  " normal mode
  let &t_EI .= "\<Esc>[0 q"
  " insert mode
  let &t_SI .= "\<Esc>[6 q"
endif

syntax enable
"colorscheme base16-mocha
"colorscheme base16-default-dark
"colorscheme solarized
set background=dark
