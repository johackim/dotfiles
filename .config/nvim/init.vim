call plug#begin('~/.config/nvim')
  Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim', { 'tag': 'v0.0.81', 'do': 'yarn install' }
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'jamessan/vim-gnupg'
  Plug 'dense-analysis/ale'
  Plug 'tpope/vim-surround'
  Plug 'dylanaraps/wal.vim'
  Plug 'vim-scripts/colorizer'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'
  Plug 'preservim/nerdcommenter'
  Plug 'prettier/vim-prettier'
  Plug 'matze/vim-move'
  Plug 'Raimondi/delimitMate'
  Plug 'mattn/emmet-vim'
  Plug 'amadeus/vim-mjml'
  Plug 'yuezk/vim-js'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'ryanoasis/vim-devicons'
  Plug 'vimwiki/vimwiki'
  Plug 'github/copilot.vim'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
  Plug 'hrsh7th/nvim-cmp'
  Plug 'roobert/tailwindcss-colorizer-cmp.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Key Leader
let mapleader = ","

" Display line number
set number

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

" Theme
colorscheme wal
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" Copy to the clipboard
set clipboard+=unnamedplus

" Search
set ignorecase " Ignore Case
set smartcase  " If a search contains a capital letter, case is re-enabled
set incsearch  " Highlights search results while typing
set hlsearch   " Highlights search results

" NerdTREE configuration
let NERDTreeShowHidden=1
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" CtrlP configuration
let g:ctrlp_map = '<leader>p'
nmap <Leader>lb :CtrlPBuffer<cr>
nmap <Leader>m :CtrlPBufTag<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_show_hidden = 1
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = ''
let g:ctrlp_open_new_file = 'r'

" vim-gnupg configuration
let g:GPGDefaultRecipients=["johackim"]

" Airline configuration
let g:airline_section_warning = ''
let g:airline_section_error = ''
let g:airline_powerline_fonts = 1

" NERDCommenter configuration
noremap <c-_> :call NERDComment(0, "Toggle")<cr>
let g:NERDSpaceDelims = 2

" Markdown configuration
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

" Prettier configuration
nmap <Leader>b <Plug>(Prettier)

" Vim-move configuration
let g:move_map_keys = 0
vmap <C-j> <Plug>MoveBlockDown
vmap <C-k> <Plug>MoveBlockUp
nmap <A-j> <Plug>MoveLineDown

" Hide status bar
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
        set nonumber
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set number
    endif
endfunction
nnoremap <S-h> :call ToggleHiddenAll()<CR>

" Vimwiki configuration
let g:vimwiki_conceallevel = 0
set concealcursor=nc

" Vim-instant-markdown configuration
let g:instant_markdown_autostart = 0

" Github copilot configuration
let g:copilot_enabled = v:false
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

" Ale
nnoremap <leader>f :ALEFix<CR>
let g:ale_fix_on_save = 1
let g:ale_fixers = { 'javascript': ['eslint'] }

" Disable mouse
set mouse=
