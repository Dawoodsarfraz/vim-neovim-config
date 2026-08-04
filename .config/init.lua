-- ============================================================================
-- init.lua — Neovim 0.12 config
-- Same settings & keymaps as your original .vimrc.
-- Plugin manager: lazy.nvim (was vim-plug)
-- Completion/LSP: native LSP + mason.nvim + blink.cmp (was coc.nvim)
-- Everything else (NERDTree, tagbar, airline, vimtex, colorschemes, etc.)
-- kept exactly as in your original config.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Basic settings (from :set lines) — UNCHANGED
-- ----------------------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.softtabstop = 4
vim.o.mouse = "a"
vim.o.encoding = "utf-8"
vim.o.completeopt = "menu,menuone,noselect" -- for blink.cmp (was completeopt-=preview)

vim.g.maplocalleader = ","

-- ----------------------------------------------------------------------------
-- lazy.nvim bootstrap
-- ----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ----------------------------------------------------------------------------
-- Plugins
-- ----------------------------------------------------------------------------
require("lazy").setup({

  -- === Kept exactly as original (non-LSP plugins) ===
  {"cacharle/c_formatter_42.vim"},
  { "tpope/vim-surround" },
  { "preservim/nerdtree" },
  { "tpope/vim-commentary" },
  { "vim-airline/vim-airline" },
  { "lifepillar/pgsql.vim" },
  { "ap/vim-css-color" },
  { "rafi/awesome-vim-colorschemes" },
  { "ryanoasis/vim-devicons" },
  { "tc50cal/vim-terminal" },
  { "preservim/tagbar" },
  { "terryma/vim-multiple-cursors" },
  { "sheerun/vim-polyglot" },
  { "lervag/vimtex" },
  { "drewtempelmeyer/palenight.vim" },
  { "rakr/vim-one" },
  { "dkarter/bullets.vim" },
  { "github/copilot.vim" },
  { "glepnir/dashboard-nvim" },
  { "junegunn/fzf.vim" },
  { "junegunn/fzf" },
  { "Mofiqul/dracula.nvim" },
  { "navarasu/onedark.nvim" },
  { "RRethy/nvim-base16" },
  { "simnalamburt/vim-mundo" },

  -- === Replaces coc.nvim: native LSP stack ===
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright" }, -- matches your old coc-clangd / python setup
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" }, -- Tab/Enter/Ctrl-y behave like most completion plugins
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
  {
    -- NOTE: nvim-treesitter had a full rewrite (April 2026). The old
    -- `nvim-treesitter.configs` module is gone/archived. Neovim 0.12 has
    -- highlighting built in by default, so this plugin now only installs
    -- parsers — no highlight/indent config block needed anymore.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "c", "cpp", "python", "lua", "vim", "vimdoc", "bash", "latex",
      })
    end,
  },
})

-- ----------------------------------------------------------------------------
-- LSP server setup (clangd for C/C++, pyright for Python — via mason)
-- NOTE: the old require('lspconfig').<server>.setup({}) style is deprecated
-- as of Neovim 0.11+ and will be removed in nvim-lspconfig v3.0.0.
-- nvim-lspconfig now just ships server definitions under lsp/, activated via
-- the native vim.lsp.config() / vim.lsp.enable() API instead.
-- ----------------------------------------------------------------------------
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("clangd", { capabilities = capabilities })
vim.lsp.config("pyright", { capabilities = capabilities })

vim.lsp.enable({ "clangd", "pyright" })

-- ----------------------------------------------------------------------------
-- Dashboard
-- ----------------------------------------------------------------------------
vim.g.dashboard_default_executive = "fzf"

-- ----------------------------------------------------------------------------
-- Keymaps — SAME as original, only <C-l> now points to native LSP
-- (was CocActionAsync('jumpDefinition')), and the manual <Tab> completion
-- mapping is removed since blink.cmp handles Tab itself via its own keymap.
-- ----------------------------------------------------------------------------
vim.keymap.set("n", "<C-f>", ":NERDTreeFocus<CR>")
vim.keymap.set("n", "<C-n>", ":NERDTree<CR>")
vim.keymap.set("n", "<C-t>", ":NERDTreeToggle<CR>")
vim.keymap.set("n", "<C-l>", vim.lsp.buf.definition, { desc = "Go to definition (native LSP)" })
vim.keymap.set("n", "<F8>", ":TagbarToggle<CR>")

-- ----------------------------------------------------------------------------
-- NERDTree arrows — UNCHANGED
-- ----------------------------------------------------------------------------
vim.g.NERDTreeDirArrowExpandable = "+"
vim.g.NERDTreeDirArrowCollapsible = "~"

-- ----------------------------------------------------------------------------
-- Notes (updated: CocInstall -> Mason, PlugInstall -> Lazy)
-- ----------------------------------------------------------------------------
-- :Lazy clean / :Lazy install / :Lazy update   (was :PlugClean :PlugInstall :UpdateRemotePlugins)
--
-- :Mason                       -- opens UI to install/manage LSP servers
-- clangd  -> installed via mason-lspconfig ensure_installed above
-- pyright -> installed via mason-lspconfig ensure_installed above
-- (coc-snippets equivalent: LuaSnip, not added here — say the word if you want it)

-- ----------------------------------------------------------------------------
-- Airline — UNCHANGED
-- ----------------------------------------------------------------------------
vim.g.airline_powerline_fonts = 1

if vim.g.airline_symbols == nil then
  vim.g.airline_symbols = {}
end

vim.g.bullets_enabled_file_types = { "markdown", "text" }

vim.g.airline_left_sep = "▶"
vim.g.airline_left_alt_sep = "❱"
vim.g.airline_right_sep = "◀"
vim.g.airline_right_alt_sep = "❰"

vim.cmd([[
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.readonly = '🔒'
  let g:airline_symbols.linenr = 'lₙ'
]])

vim.g.airline_theme = "onedark"

-- ----------------------------------------------------------------------------
-- Filetype detection — UNCHANGED
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.asm",
  command = "set filetype=nasm",
})

-- ----------------------------------------------------------------------------
-- VimTeX section — UNCHANGED
-- ----------------------------------------------------------------------------
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_general_viewer = "okular"
vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
vim.g.vimtex_view_general_options_latexmk = "--unique"
