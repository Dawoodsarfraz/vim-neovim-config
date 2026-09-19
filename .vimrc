" ============================================================================
" .vimrc — Vim 9
" ============================================================================
" Terminal Vim configuration
"
" Features:
"   - Nerd Font icons
"   - NERDTree file/folder icons
"   - Airline statusline
"   - Coc.nvim LSP/completion
"   - Vimspector debugging
"   - Buffer management
"   - VimTeX
"   - FZF
"   - Tagbar
"   - GitHub Copilot
"   - Multiple cursors
"   - Polyglot
"   - True black theme
" ============================================================================


" ============================================================================
" BASIC SETTINGS
" ============================================================================

set number
set relativenumber

set autoindent
set smartindent

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set smarttab

set mouse=a
set clipboard=unnamedplus

set encoding=utf-8
set fileencoding=utf-8

set termguicolors

set hidden
set nowrap

set cursorline

set showmode
set showcmd

set splitbelow
set splitright

set updatetime=300

set shortmess+=c

set signcolumn=yes

set completeopt=menuone,noinsert,noselect

set wildmenu
set wildmode=longest:full,full

set scrolloff=8
set sidescrolloff=8

set history=1000

set nobackup
set nowritebackup
set noswapfile

set incsearch
set hlsearch

set ignorecase
set smartcase

set laststatus=2

set title

set encoding=UTF-8


" ============================================================================
" LEADER
" ============================================================================

let mapleader = "\<Space>"
let maplocalleader = ","


" ============================================================================
" PLUGIN MANAGER
" ============================================================================

filetype off

call plug#begin()


" ============================================================================
" FORMATTING / EDITING
" ============================================================================

Plug 'cacharle/c_formatter_42.vim'

Plug 'http://github.com/tpope/vim-surround'

Plug 'https://github.com/tpope/vim-commentary'

Plug 'https://github.com/terryma/vim-multiple-cursors'

Plug 'https://github.com/dkarter/bullets.vim'


" ============================================================================
" FILE EXPLORER / NAVIGATION
" ============================================================================

Plug 'https://github.com/preservim/nerdtree'

Plug 'https://github.com/ryanoasis/vim-devicons'

Plug 'https://github.com/preservim/tagbar'


" ============================================================================
" SEARCH
" ============================================================================

Plug 'https://github.com/junegunn/fzf'

Plug 'https://github.com/junegunn/fzf.vim'


" ============================================================================
" UI / STATUSLINE
" ============================================================================

Plug 'https://github.com/vim-airline/vim-airline'


" ============================================================================
" COLORS / THEMES
" ============================================================================

Plug 'https://github.com/rafi/awesome-vim-colorschemes'

Plug 'https://github.com/drewtempelmeyer/palenight.vim'

Plug 'https://github.com/rakr/vim-one'

Plug 'https://github.com/Mofiqul/dracula.nvim'

Plug 'https://github.com/navarasu/onedark.nvim'

Plug 'https://github.com/RRethy/nvim-base16'


" ============================================================================
" LANGUAGES
" ============================================================================

Plug 'https://github.com/sheerun/vim-polyglot'


" ============================================================================
" TERMINAL
" ============================================================================

Plug 'https://github.com/tc50cal/vim-terminal'


" ============================================================================
" DATABASE
" ============================================================================

Plug 'https://github.com/lifepillar/pgsql.vim'


" ============================================================================
" CSS
" ============================================================================

Plug 'https://github.com/ap/vim-css-color'


" ============================================================================
" LATEX
" ============================================================================

" Plug 'https://github.com/conornewton/vim-latex-preview'

Plug 'https://github.com/lervag/vimtex'


" ============================================================================
" COPILOT
" ============================================================================

Plug 'github/copilot.vim'


" ============================================================================
" DASHBOARD
" ============================================================================

Plug 'https://github.com/glepnir/dashboard-nvim'


" ============================================================================
" UNDO HISTORY
" ============================================================================

Plug 'https://github.com/simnalamburt/vim-mundo'


" ============================================================================
" LSP / COMPLETION
" ============================================================================

Plug 'neoclide/coc.nvim', {'branch': 'release'}


" ============================================================================
" DEBUGGER
" ============================================================================

Plug 'puremourning/vimspector'


" ============================================================================
" BUFFER MANAGEMENT
" ============================================================================

Plug 'ap/vim-buftabline'

Plug 'moll/vim-bbye'


" ============================================================================
" DASHBOARD
" ============================================================================

let g:dashboard_default_executive = 'fzf'


" ============================================================================
" END PLUGINS
" ============================================================================

call plug#end()


" ============================================================================
" COLORS — TRUE BLACK THEME
" ============================================================================

silent! colorscheme dracula

" Other available themes:
"
" colorscheme onedark
" colorscheme palenight
" colorscheme one
"
" Change the line above to try another theme. The black override below
" applies on top of whichever theme you pick, so syntax colors stay but
" the background always renders as pure black (#000000).

highlight Normal       guibg=#000000 ctermbg=0
highlight NonText      guibg=#000000 ctermbg=0
highlight SignColumn   guibg=#000000 ctermbg=0
highlight LineNr       guibg=#000000 ctermbg=0
highlight CursorLineNr guibg=#000000 ctermbg=0
highlight EndOfBuffer  guibg=#000000 ctermbg=0
highlight VertSplit    guibg=#000000 ctermbg=0
highlight StatusLine   guibg=#000000 ctermbg=0
highlight StatusLineNC guibg=#000000 ctermbg=0
highlight Pmenu        guibg=#000000 ctermbg=0
highlight PmenuSel     guibg=#1a1a1a ctermbg=0
highlight FoldColumn   guibg=#000000 ctermbg=0
highlight Folded       guibg=#000000 ctermbg=0


" ============================================================================
" NERDTREE
" ============================================================================

" Open / focus NERDTree
nnoremap <C-f> :NERDTreeFocus<CR>

" Open NERDTree
nnoremap <C-n> :NERDTree<CR>

" Toggle NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>


" ----------------------------------------------------------------------------
" NERDTree appearance
" ----------------------------------------------------------------------------

let g:NERDTreeShowHidden = 1

let g:NERDTreeMinimalUI = 0

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" NERDTree black background
autocmd FileType nerdtree highlight NERDTreeCWD guibg=#000000
autocmd FileType nerdtree highlight Normal      guibg=#000000


" ----------------------------------------------------------------------------
" vim-devicons
" ----------------------------------------------------------------------------

let g:webdevicons_enable_nerdtree = 1

let g:webdevicons_enable_airline_statusline = 1

let g:webdevicons_enable_startify = 1

let g:webdevicons_conceal_nerdtree_brackets = 1

let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '


" ============================================================================
" GENERAL KEYMAPS
" ============================================================================

" Go to definition
nnoremap <C-l> <Plug>(coc-definition)

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Disable search highlight
nnoremap <Esc> :nohlsearch<CR>


" ============================================================================
" COC.NVIM
" ============================================================================

set completeopt=menuone,noinsert,noselect

set updatetime=300

set shortmess+=c

set signcolumn=yes


" ----------------------------------------------------------------------------
" Check Backspace
" ----------------------------------------------------------------------------

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction


" ----------------------------------------------------------------------------
" Completion
" ----------------------------------------------------------------------------

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB>
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ "\<C-h>"

inoremap <silent><expr> <CR>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>"


" ----------------------------------------------------------------------------
" Manually trigger completion
" ----------------------------------------------------------------------------

inoremap <silent><expr> <C-Space> coc#refresh()


" ----------------------------------------------------------------------------
" Hover documentation
" ----------------------------------------------------------------------------

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation() abort

    if CocAction('hasProvider', 'hover')

        call CocActionAsync('doHover')

    else

        call feedkeys('K', 'in')

    endif

endfunction


" ----------------------------------------------------------------------------
" Navigation
" ----------------------------------------------------------------------------

nmap <silent> gd <Plug>(coc-definition)

nmap <silent> gr <Plug>(coc-references)

nmap <silent> gy <Plug>(coc-type-definition)

nmap <silent> gi <Plug>(coc-implementation)


" ----------------------------------------------------------------------------
" Rename
" ----------------------------------------------------------------------------

nmap <leader>rn <Plug>(coc-rename)


" ----------------------------------------------------------------------------
" Code actions
" ----------------------------------------------------------------------------

nmap <leader>ca <Plug>(coc-codeaction)


" ----------------------------------------------------------------------------
" Diagnostics
" ----------------------------------------------------------------------------

nnoremap <leader>e :CocDiagnostics<CR>

nnoremap <leader>dn :CocNext<CR>

nnoremap <leader>dp :CocPrev<CR>


" ----------------------------------------------------------------------------
" Coc notes
" ----------------------------------------------------------------------------
"
" C/C++:
"
"   :CocInstall coc-clangd
"
" Python:
"
"   :CocInstall coc-pyright
"
" JavaScript:
"
"   :CocInstall coc-tsserver
"
"
" Check Coc:
"
"   :CocInfo
"
"   :CocList services
"
"   :CocList extensions
"
" ============================================================================


" ============================================================================
" VIMSPECTOR DEBUGGER
" ============================================================================

let g:vimspector_enable_mappings = 'HUMAN'


" ----------------------------------------------------------------------------
" Vimspector UI
" ----------------------------------------------------------------------------

let g:vimspector_sidebar_width = 40

let g:vimspector_bottombar_height = 12

let g:vimspector_terminal_maxwidth = 70

let g:vimspector_ui_mode = 'unicode'

let g:vimspector_variables_display_mode = 'compact'


" ----------------------------------------------------------------------------
" Debug keymaps
" ----------------------------------------------------------------------------

" Toggle breakpoint
nnoremap <leader>db :call vimspector#ToggleBreakpoint()<CR>

" Continue
nnoremap <leader>dc :call vimspector#Continue()<CR>

" Step over
nnoremap <leader>do :call vimspector#StepOver()<CR>

" Step into
nnoremap <leader>di :call vimspector#StepInto()<CR>

" Step out
nnoremap <leader>dO :call vimspector#StepOut()<CR>

" Reset debugger
nnoremap <leader>dq :call vimspector#Reset()<CR>

" Toggle tag/watch
nnoremap <leader>du :call vimspector#ToggleTag()<CR>


" ----------------------------------------------------------------------------
" Vimspector signs
" ----------------------------------------------------------------------------

sign define vimspectorBP
      \ text=●
      \ texthl=DiagnosticSignError

sign define vimspectorBPCond
      \ text=◆
      \ texthl=DiagnosticSignWarn

sign define vimspectorBPDisabled
      \ text=○
      \ texthl=Comment

sign define vimspectorPC
      \ text=▶
      \ texthl=DiagnosticSignWarn
      \ linehl=CursorLine


" ----------------------------------------------------------------------------
" Vimspector panel colors — black backgrounds, colored titles
" ----------------------------------------------------------------------------

highlight VimspectorVariablesTitle
      \ guifg=#7dcfff
      \ gui=bold
      \ guibg=#000000

highlight VimspectorWatchesTitle
      \ guifg=#bb9af7
      \ gui=bold
      \ guibg=#000000

highlight VimspectorStackTraceTitle
      \ guifg=#9ece6a
      \ gui=bold
      \ guibg=#000000



" ============================================================================
" BUFFER TABLINE
" ============================================================================

let g:buftabline_show = 2

let g:buftabline_numbers = 2


" ----------------------------------------------------------------------------
" Buffer navigation
" ----------------------------------------------------------------------------

nnoremap <A-Left> :bprevious<CR>

nnoremap <A-Right> :bnext<CR>

nnoremap <A-h> :bprevious<CR>

nnoremap <A-l> :bnext<CR>


" ----------------------------------------------------------------------------
" Close buffer
" ----------------------------------------------------------------------------

nnoremap <C-q> :Bdelete<CR>


" ============================================================================
" AIRLINE
" ============================================================================

let g:airline_powerline_fonts = 1


if !exists('g:airline_symbols')

    let g:airline_symbols = {}

endif


" ----------------------------------------------------------------------------
" Nerd Font / Unicode symbols
" ----------------------------------------------------------------------------

let g:airline_left_sep = ''

let g:airline_left_alt_sep = ''

let g:airline_right_sep = ''

let g:airline_right_alt_sep = ''


" ----------------------------------------------------------------------------
" Airline symbols
" ----------------------------------------------------------------------------

let g:airline_symbols.branch = ''

let g:airline_symbols.readonly = '🔒'

let g:airline_symbols.linenr = '☰'

let g:airline_symbols.maxlinenr = '☷'

let g:airline_symbols.dirty = '●'


" ----------------------------------------------------------------------------
" Airline theme — black variant
" ----------------------------------------------------------------------------

let g:airline_theme = 'onedark'
" If 'base16_black' isn't available on your system, fall back to onedark:
"   let g:airline_theme = 'onedark'


" ============================================================================
" BULLETS
" ============================================================================

let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text'
    \ ]


" ============================================================================
" TAGBAR
" ============================================================================

let g:tagbar_width = 30

let g:tagbar_compact = 1


" ============================================================================
" FZF
" ============================================================================

let g:fzf_layout = {
    \ 'window': {
        \ 'width': 0.90,
        \ 'height': 0.80
    \ }
\ }


" ============================================================================
" FILE TYPES
" ============================================================================

augroup custom_filetypes

    autocmd!

    autocmd BufRead,BufNewFile *.asm set filetype=nasm

augroup END


" ============================================================================
" VIMTEX
" ============================================================================

filetype plugin indent on

syntax enable


" ----------------------------------------------------------------------------
" Viewer
" ----------------------------------------------------------------------------

let g:vimtex_view_method = 'zathura'


" ----------------------------------------------------------------------------
" Generic viewer
" ----------------------------------------------------------------------------

let g:vimtex_view_general_viewer = 'okular'

let g:vimtex_view_general_options =
      \ '--unique file:@pdf\#src:@line@tex'

let g:vimtex_view_general_options_latexmk =
      \ '--unique'


" ============================================================================
" VIM MUNDO
" ============================================================================

nnoremap <leader>u :MundoToggle<CR>


" ============================================================================
" USEFUL GENERAL KEYMAPS
" ============================================================================

" Save
nnoremap <C-s> :write<CR>

" Quit
nnoremap <C-x> :quit<CR>

" Save and quit
nnoremap <leader>wq :wq<CR>

" Split horizontally
nnoremap <leader>sh :split<CR>

" Split vertically
nnoremap <leader>sv :vsplit<CR>

" Move between splits
nnoremap <C-h> <C-w>h

nnoremap <C-j> <C-w>j

nnoremap <C-k> <C-w>k

nnoremap <C-l> <C-w>l


" ============================================================================
" TERMINAL
" ============================================================================

" Open terminal
nnoremap <leader>tt :VimTerminal<CR>


" ============================================================================
" INDENTATION
" ============================================================================

" Keep selection after indenting
vnoremap < <gv

vnoremap > >gv


" ============================================================================
" VISUAL SETTINGS
" ============================================================================

" Show whitespace
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮

" Don't show whitespace by default
set nolist


" ============================================================================
" FINAL
" ============================================================================

" Remove completion preview window
set completeopt-=preview

" Make cursor line easier to see
set cursorline

" Keep sign column stable
set signcolumn=yes

" Enable syntax
syntax enable

" ============================================================================
" END OF .vimrc
" ============================================================================
