" ============================================================================
" .vimrc — Vim 9
" Same settings, keymaps, and non-LSP plugins as your original config.
" LSP/completion: coc.nvim (replaces the vim-lsp/asyncomplete stack)
" ============================================================================

" ----------------------------------------------------------------------------
" Basic settings — UNCHANGED
" ----------------------------------------------------------------------------
:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
set clipboard=unnamedplus

filetype off
call plug#begin()

" === Kept exactly as original (non-LSP plugins) ===
Plug 'cacharle/c_formatter_42.vim'
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/lifepillar/pgsql.vim' " PSQL Pluging needs :SQLSetType pgsql.vim
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
Plug 'https://github.com/sheerun/vim-polyglot'
" Plug 'https://github.com/conornewton/vim-latex-preview' " Vim Latex Plugin
Plug 'https://github.com/lervag/vimtex' " Vim Latex Plugin
Plug 'https://github.com/drewtempelmeyer/palenight.vim' " Palenight
Plug 'https://github.com/rakr/vim-one' " One Colorscheme
Plug 'https://github.com/dkarter/bullets.vim'
Plug 'github/copilot.vim'
Plug 'https://github.com/glepnir/dashboard-nvim'
Plug 'https://github.com/junegunn/fzf.vim' " Fuzzy Finder, Needs Silversearcher-ag for :Ag
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/Mofiqul/dracula.nvim'
Plug 'https://github.com/navarasu/onedark.nvim'
Plug 'https://github.com/RRethy/nvim-base16'
Plug 'https://github.com/simnalamburt/vim-mundo'

" === coc.nvim — replaces vim-lsp + asyncomplete + vim-lsp-settings ===
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:dashboard_default_executive ='fzf'
set encoding=UTF-8
call plug#end()

" ----------------------------------------------------------------------------
" Keymaps — SAME as original, <C-l> now maps to coc's go-to-definition
" ----------------------------------------------------------------------------
nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-l> <Plug>(coc-definition)
nmap <F8> :TagbarToggle<CR>

:set completeopt-=preview " For No Previews

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" ----------------------------------------------------------------------------
" coc.nvim core settings and keybindings (standard recommended config)
" ----------------------------------------------------------------------------
set completeopt=menuone,noinsert,noselect
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Tab to trigger/navigate completion, Enter to confirm
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Manually trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Hover documentation with K
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Go to references
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gd <Plug>(coc-definition)

" --- Just Some Notes ----
" :PlugClean :PlugInstall :PlugUpdate
"
" First time setup for C/C++:
"   :CocInstall coc-clangd
" Check status:
"   :CocInfo
"   :CocList services       -- list running language servers

" air-line
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text'
    \]

" airline symbols
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❱'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❰'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.readonly = '🔒'
let g:airline_symbols.linenr = 'lₙ'

au BufRead,BufNewFile *.asm set filetype=nasm

" :colorscheme one
let g:airline_theme='onedark'

"VIMTEX SECTION
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
