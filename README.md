# C/C++ IntelliSense Setup Guide (clangd)

This guide documents how to set up **clangd**-powered code completion for C/C++ in both **Vim** (via vim-lsp) and **VS Code** (via the clangd extension) on Ubuntu.

---

## 1. Install clangd (required for both editors)

```bash
sudo apt update
sudo apt install clangd
```

Verify installation:

```bash
which clangd
clangd --version
```

Expected output (versions may differ):
```
/usr/bin/clangd
Ubuntu clangd version 14.0.0-1ubuntu1.1
Features: linux+grpc
Platform: x86_64-pc-linux-gnu
```

---

## 2. Vim Setup (vim-lsp)

### 2.1 Plugins required

Make sure these are in your `.vimrc` (via vim-plug):

```vim
call plug#begin()

Plug 'prabirshrestha/vim-lsp'                 " Core LSP client
Plug 'mattn/vim-lsp-settings'                 " Auto-installs & configures servers
Plug 'prabirshrestha/asyncomplete.vim'        " Completion engine
Plug 'prabirshrestha/asyncomplete-lsp.vim'    " Bridges asyncomplete <-> vim-lsp

call plug#end()
```

Then install them:

```vim
:PlugInstall
```

### 2.2 Register vim-lsp as a completion source

Add this **after** `call plug#end()` in your `.vimrc`:

```vim
" Register vim-lsp as an asyncomplete source
au User lsp_buffer_enabled call asyncomplete#register_source(
    \ asyncomplete#sources#lsp#get_source_options({
    \   'name': 'lsp',
    \   'whitelist': ['*'],
    \   'completor': function('asyncomplete#sources#lsp#completor'),
    \ }))

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> K  <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
```

### 2.3 Manually register clangd (bypasses vim-lsp-settings auto-installer)

Since `vim-lsp-settings`' built-in downloader can fail (missing curl/network/permissions), register the system-installed clangd directly:

```vim
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif
```

> Note: depending on your `vim-lsp` version, this key may be `'whitelist'` instead of `'allowlist'`. Try one, and switch if you get an error.

### 2.4 Completion keybindings (Tab to navigate suggestions)

```vim
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
```

### 2.5 Verify it's working

Open a `.c` file in vim, then run:

```vim
:LspStatus
```

You should see `clangd: running`. If not, check:

```vim
:messages
```

for errors, and confirm plugins loaded with:

```vim
:PlugStatus
```

---

## 3. VS Code Setup (clangd extension)

### 3.1 Install VS Code (if needed)

```bash
sudo snap install --classic code
```

### 3.2 Install the clangd extension

```bash
code --install-extension llvm-vs-code-extensions.vscode-clangd
```

### 3.3 Disable Microsoft's built-in IntelliSense (avoid conflicts)

If you also have the default `ms-vscode.cpptools` extension installed, disable its IntelliSense engine so it doesn't compete with clangd.

### 3.4 settings.json configuration

Open settings.json (`Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)") and add:

```jsonc
{
    "C_Cpp.intelliSenseEngine": "disabled",
    "clangd.path": "/usr/bin/clangd",
    "clangd.arguments": [
        "--background-index",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--clang-tidy"
    ],
    "editor.quickSuggestions": {
        "other": true,
        "comments": false,
        "strings": false
    },
    "editor.suggestOnTriggerCharacters": true,
    "editor.acceptSuggestionOnEnter": "on"
}
```

**What the clangd arguments do:**
| Flag | Purpose |
|---|---|
| `--background-index` | Indexes the whole project for cross-file suggestions |
| `--completion-style=detailed` | Richer suggestion popups with full signatures |
| `--header-insertion=iwyu` | Auto-inserts `#include` lines when needed |
| `--clang-tidy` | Adds linting/static analysis warnings |

### 3.5 Generate `compile_commands.json` (important for real projects)

Without this file, clangd can only guess include paths/flags for your own project headers — leading to incomplete suggestions.

**CMake projects:**
```bash
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json .
```

**Makefile projects:**
```bash
sudo apt install bear
bear -- make
```

**Single-file / no build system:** not required — clangd works fine with standard headers alone.

### 3.6 Reload and verify

1. Reload window: `Ctrl+Shift+P` → "Developer: Reload Window"
2. Open a `.c`/`.cpp` file
3. Check the **bottom status bar** for a "clangd" indicator — click it to see status (should say "idle" once ready, not an error)
4. Force-trigger suggestions with `Ctrl+Space` if they don't appear automatically while typing

### 3.7 Quick isolated test

```bash
mkdir -p ~/test-c && cd ~/test-c
cat > test.c << 'EOF'
#include <stdio.h>

int main() {
    printf(
    return 0;
}
EOF
code .
```

Place cursor after `printf(` and press `Ctrl+Space` — you should see parameter hints for `printf`.

---

## 4. Neovim Setup (nvim-lspconfig — recommended modern approach)

Neovim has built-in LSP client support (since 0.5+), so instead of `vim-lsp`, the standard approach is `nvim-lspconfig` + a completion engine like `nvim-cmp`.

### 4.1 Plugin manager

Examples below use [lazy.nvim](https://github.com/folke/lazy.nvim). If you use `packer.nvim` or `vim-plug` instead, the plugin names are the same — just adapt the syntax.

If you don't have lazy.nvim yet, install it first: https://github.com/folke/lazy.nvim#installation

### 4.2 Required plugins

In your `init.lua` (or a plugins file loaded by lazy.nvim):

```lua
require("lazy").setup({
    "neovim/nvim-lspconfig",     -- LSP configs, incl. clangd
    "hrsh7th/nvim-cmp",          -- Completion engine
    "hrsh7th/cmp-nvim-lsp",      -- LSP source for nvim-cmp
    "hrsh7th/cmp-buffer",        -- Buffer word completion
    "hrsh7th/cmp-path",          -- Filesystem path completion
    "L3MON4D3/LuaSnip",          -- Snippet engine
    "saadparwaiz1/cmp_luasnip",  -- Snippet source for nvim-cmp
})
```

Run `:Lazy sync` (or `:PackerSync` / `:PlugInstall` depending on your manager) to install.

### 4.3 Configure clangd via nvim-lspconfig

```lua
local lspconfig = require('lspconfig')

lspconfig.clangd.setup({
    cmd = { "clangd", "--background-index", "--completion-style=detailed",
            "--header-insertion=iwyu", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})
```

### 4.4 Configure nvim-cmp (the completion popup itself)

```lua
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    }),
})
```

### 4.5 Hook LSP capabilities into cmp (important — easy to miss)

By default, Neovim's LSP client doesn't advertise the completion capabilities nvim-cmp needs. Add this **before** your `lspconfig.clangd.setup()` call and pass it in:

```lua
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup({
    capabilities = capabilities,
    cmd = { "clangd", "--background-index", "--completion-style=detailed",
            "--header-insertion=iwyu", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})
```

### 4.6 Optional: keymaps on LSP attach

```lua
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-l>', vim.lsp.buf.definition, opts)
    end,
})
```

### 4.7 Generate `compile_commands.json`

Same idea as the VS Code section (3.5 above) — clangd needs this for accurate project-wide suggestions:

```bash
# CMake
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json .

# Makefile
sudo apt install bear
bear -- make
```

### 4.8 Verify it's working

Open a `.c` file in nvim, then run:

```vim
:LspInfo
```

You should see `clangd` listed as attached and running. If not:

```vim
:checkhealth lsp
:messages
```

Force-trigger completion manually with `<C-Space>` (as mapped in 4.4) to rule out auto-popup issues.

---

## 6. Troubleshooting Checklist

| Symptom | Likely Cause | Fix |
|---|---|---|
| `:LspInstallServer` fails in Vim | `vim-lsp-settings` downloader can't reach network / missing curl / permissions | Install clangd via `apt` and register manually (section 2.3) |
| `:LspStatus` shows nothing (Vim) | Plugin not loaded or registration block missing | Run `:PlugStatus`, check `.vimrc` for typos, run `:messages` |
| clangd status bar missing in VS Code | Extension not activating for the file | Check bottom-right language mode says "C"/"C++", not "Plain Text" |
| clangd shows "idle" but no suggestions | Auto-suggest settings disabled, or file not indexed | Try `Ctrl+Space` manually; check `editor.quickSuggestions` settings (VS Code) |
| `:LspInfo` shows no client attached (Neovim) | `capabilities` not passed to `lspconfig.clangd.setup()`, or filetype mismatch | Confirm step 4.5 is applied; check `:set filetype?` shows `c`/`cpp` |
| No completions in Neovim despite LSP attached | `nvim-cmp` sources missing `nvim_lsp`, or capabilities not wired up | Recheck sections 4.4 and 4.5 |
| Suggestions missing for your own project headers | No `compile_commands.json` | Generate via CMake or `bear` (section 3.5 / 4.7) |
| Settings not applying (VS Code) | JSON syntax error elsewhere in file | Validate `settings.json` — check for trailing commas/missing brackets |

### Useful diagnostic commands

**Vim:**
```vim
:LspStatus
:LspManageServers
:messages
:PlugStatus
```

**Neovim:**
```vim
:LspInfo
:checkhealth lsp
:messages
:Lazy
```

**VS Code:**
- Output panel (`Ctrl+Shift+U`) → select "clangd" from dropdown → view server log
- Command Palette → "clangd: Restart language server"

---

## 7. System Info Reference

Confirmed working environment for this guide:
```
OS: Ubuntu
clangd path: /usr/bin/clangd
clangd version: 14.0.0-1ubuntu1.1
Features: linux+grpc
Platform: x86_64-pc-linux-gnu
```
