call plug#begin('~/.config/nvim')
  Plug 'preservim/nerdtree'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'jamessan/vim-gnupg'
  Plug 'dense-analysis/ale'
  Plug 'dylanaraps/wal.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'airblade/vim-gitgutter'
  Plug 'preservim/nerdcommenter'
  Plug 'matze/vim-move'
  Plug 'Raimondi/delimitMate'
  Plug 'ryanoasis/vim-devicons'
  Plug 'github/copilot.vim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'neoclide/coc.nvim', { 'tag': 'v0.0.81', 'do': 'yarn install' }
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && ./install.sh' }
call plug#end()

" Key Leader
let mapleader = ","

" Display line number
set number

" Disable automatic newline at end of file
set nofixendofline
set noeol

" Disable mouse
set mouse=

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Theme
colorscheme wal
set notermguicolors
highlight Pmenu guibg=none ctermbg=none ctermfg=7 cterm=none
highlight PmenuSel guibg=none ctermbg=4 ctermfg=0 cterm=none

" Clipboard
set clipboard+=unnamedplus

" Search
set ignorecase
set smartcase

" NerdTREE
let NERDTreeShowHidden=1
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && &filetype == 'nerdtree' | quit | endif

" CtrlP
let g:ctrlp_map = '<leader>p'
nmap <Leader>lb :CtrlPBuffer<CR>
let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob "!.git/*"'
let g:ctrlp_use_caching = 0
let g:ctrlp_status_func = {'main':'F','prog':'F'}
function! F(...)
  return ''
endfunction

" NERD Commenter
let g:NERDSpaceDelims = 2

" Vim-move
vmap <C-j> <Plug>MoveBlockDown
vmap <C-k> <Plug>MoveBlockUp

" Github copilot
let g:copilot_enabled = v:false
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

" Ale
let g:ale_fix_on_save = 1
let g:ale_fixers = { 'javascript': ['eslint'] }

" Coc.nvim
let s:asdf_node = expand('~/.asdf/shims/node')
if executable(s:asdf_node)
  let g:coc_node_path = s:asdf_node
endif

" Treesitter
lua << EOF
pcall(function()
  require('nvim-treesitter').install({ "javascript", "markdown", "json", "html", "css", "vim" })
end)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { "javascript", "markdown", "json", "html", "css", "vim" },
  callback = function() pcall(vim.treesitter.start) end,
})
EOF
