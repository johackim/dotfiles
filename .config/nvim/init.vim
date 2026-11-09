lua << EOF
vim.pack.add({
  'https://github.com/preservim/nerdtree',
  'https://github.com/ctrlpvim/ctrlp.vim',
  'https://github.com/jamessan/vim-gnupg',
  'https://github.com/dense-analysis/ale',
  'https://github.com/dylanaraps/wal.vim',
  'https://github.com/airblade/vim-gitgutter',
  'https://github.com/Raimondi/delimitMate',
  'https://github.com/github/copilot.vim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
}, { confirm = false })

-- Treesitter
local langs = { "javascript", "markdown", "json", "html", "css", "vim" }
pcall(function() require('nvim-treesitter').install(langs) end)
vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function() pcall(vim.treesitter.start) end,
})

-- Markdown preview
vim.api.nvim_create_user_command('MarkdownPreview', function()
  local buf, html = vim.api.nvim_get_current_buf(), vim.fn.tempname() .. '.html'
  local function render()
    local markdown = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
    vim.fn.writefile({
      '<!doctype html><meta charset="utf-8">',
      '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/github-markdown-css@5.8.1/github-markdown.min.css">',
      '<script src="https://cdn.jsdelivr.net/npm/marked@15.0.12/marked.min.js"></script>',
      '<body class="markdown-body" style="max-width:900px;margin:auto;padding:2em">',
      '<script>document.body.innerHTML = marked.parse(' .. vim.json.encode(markdown):gsub('<', '\\u003c') .. ')</script>',
    }, html)
  end
  render()
  vim.api.nvim_create_autocmd('BufWritePost', { buffer = buf, callback = render })
  vim.ui.open(html)
end, {})
EOF

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

" vim-gnupg configuration
let g:GPGDefaultRecipients=["johackim"]

" Move selected lines
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Github copilot
let g:copilot_enabled = v:false
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

" Ale
let g:ale_fix_on_save = 1
let g:ale_fixers = { 'javascript': ['eslint'] }

" Completion
set autocomplete
