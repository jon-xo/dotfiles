call plug#begin("~/.vim/plugged")
    " Plugin Section
    Plug 'arcticicestudio/nord-vim'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-airline/vim-airline'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'tpope/vim-surround'
    Plug 'townk/vim-autoclose'
    Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'roxma/vim-tmux-clipboard'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'vim-utils/vim-husk'
    " Plug 'dracula/vim'
call plug#end()

" Config Section

" if (has("termguicolors"))
" set termguicolors
" endif
syntax enable
colorscheme nord

" File Browser

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left ope
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

"Integrated Terminal

" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

" Pane Navigation

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" Editor Navigation
"
" Move lines

" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

"Add tab completion for coc_emmet
  let g:user_emmet_leader_key = '<C-e>'
  let g:user_emmet_expandabbr_key = '<C-x><C-e>'
  imap <silent><expr> <Tab> <SID>expand()

  function! s:expand()
    if pumvisible()
      return "\<C-y>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1]  =~# '\s'
      return "\<Tab>"
    endif
    return "\<C-x>\<C-e>"
  endfunction

" Clipboard Sharing
"
set clipboard+=unnamedplus


