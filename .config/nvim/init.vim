call plug#begin('~/.config/nvim')
  Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'jamessan/vim-gnupg'
  Plug 'dense-analysis/ale'
  Plug 'tpope/vim-surround'
  Plug 'dylanaraps/wal.vim'
  Plug 'ap/vim-css-color'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'
  Plug 'preservim/nerdcommenter'
  Plug 'plasticboy/vim-markdown'
  Plug 'jistr/vim-nerdtree-tabs'
call plug#end()

" Key Leader
let mapleader = ","

" NerdTREE
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Display line number
set number

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4

" Theme
colorscheme wal
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" CtrlP
let g:ctrlp_map = '<leader>p'
nmap <Leader>lb :CtrlPBuffer<cr>
nmap <Leader>m :CtrlPBufTag<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_show_hidden = 1
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_open_new_file = 'r'

" vim-gnupg
let g:GPGDefaultRecipients=["johackim"]

" Copy to the clipboard
set clipboard+=unnamedplus

" Airline theme
let g:airline_section_warning = ''
let g:airline_section_error = ''
let g:airline_powerline_fonts = 1

" NERDCommenter config
noremap <c-_> :call NERDComment(0, "Toggle")<cr>
let g:NERDSpaceDelims = 2

" Markdown configuration
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

" Search configuration
set ignorecase " Ignore Case
set smartcase  " If a search contains a capital letter, case is re-enabled
set incsearch  " Highlights search results while typing
set hlsearch   " Highlights search results
