-- ============================================================================
-- init.lua — Neovim 0.12 config
-- Same settings & keymaps as your original .vimrc.
-- Plugin manager: lazy.nvim (was vim-plug)
-- Completion/LSP: native LSP + mason.nvim + blink.cmp (was coc.nvim)
-- Debugging: nvim-dap + nvim-dap-ui + Python/C/C++
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
vim.o.signcolumn = "yes" -- needed for breakpoint signs to show reliably

vim.g.mapleader = "\\"      -- explicit, matches your old .vimrc default
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

  -- === Buffer management (matches your Vim vim-buftabline + vim-bbye setup) ===
  { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "famiu/bufdelete.nvim" },

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

  -- ============================================================================
-- DEBUGGING
-- nvim-dap + nvim-dap-ui + Python + C/C++
-- ============================================================================

{
  "mfussenegger/nvim-dap",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
    "theHamsta/nvim-dap-virtual-text",

    -- Mason integration
    "williamboman/mason.nvim",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_python = require("dap-python")

    -- ========================================================================
    -- DAP UI
    -- ========================================================================

    dapui.setup({
      -- Left sidebar: Scopes / Breakpoints / Stacks / Watches
      layouts = {
        {
          position = "left",
          size = 35,

          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
        },

        -- Bottom: REPL / Console
        {
          position = "bottom",
          size = 10,

          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
        },
      },

      -- Control bar like the screenshot
      controls = {
        enabled = true,
        element = "repl",

        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
          disconnect = "",
        },
      },

      floating = {
        max_height = nil,
        max_width = nil,
        border = "single",

        mappings = {
          close = {
            "q",
            "<Esc>",
          },
        },
      },

      windows = {
        indent = 1,
      },

      render = {
        indent = 1,
        max_type_length = nil,
        max_value_lines = 100,
      },

      mappings = {
        expand = {
          "<CR>",
          "<2-LeftMouse>",
        },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
        watch = "w",
      },
    })


    -- ========================================================================
    -- Virtual text
    -- ========================================================================

    require("nvim-dap-virtual-text").setup({
      commented = true,
      virt_text_pos = "eol",
      highlight_changed_variables = true,
      show_stop_reason = true,
      all_frames = false,
    })


    -- ========================================================================
    -- PYTHON
    -- ========================================================================

    -- nvim-dap-python uses debugpy.
    --
    -- We initially use python3.
    -- The configuration below also detects .venv / venv for the program.

    dap_python.setup("python3")


    -- Automatically use project virtual environment if available.
    --
    -- Example:
    --
    -- project/
    -- ├── .venv/
    -- │   └── bin/python
    -- └── main.py

    local function get_python_path()
      local cwd = vim.fn.getcwd()

      local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/venv/bin/python",
      }

      for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 then
          return path
        end
      end

      -- Active virtual environment
      if vim.env.VIRTUAL_ENV then
        local venv_python = vim.env.VIRTUAL_ENV .. "/bin/python"

        if vim.fn.executable(venv_python) == 1 then
          return venv_python
        end
      end

      -- Fallback
      return "python3"
    end


    dap.configurations.python = {
      {
        name = "Python: Current File",
        type = "python",
        request = "launch",

        program = "${file}",

        pythonPath = get_python_path,

        cwd = "${workspaceFolder}",

        console = "integratedTerminal",

        justMyCode = false,
      },

      {
        name = "Python: Current File (Just My Code)",
        type = "python",
        request = "launch",

        program = "${file}",

        pythonPath = get_python_path,

        cwd = "${workspaceFolder}",

        console = "integratedTerminal",

        justMyCode = true,
      },
    }


    -- ========================================================================
    -- C / C++
    -- ========================================================================

    --
    -- We use CodeLLDB.
    --
    -- Install:
    --
    --     :MasonInstall codelldb
    --

    local codelldb = vim.fn.stdpath("data")
      .. "/mason/packages/codelldb/extension/adapter/codelldb"


    if vim.fn.executable(codelldb) == 1 then

      dap.adapters.codelldb = {
        type = "executable",
        command = codelldb,
      }

    else

      -- Fallback if codelldb is already in PATH.
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

    end


    local cpp_config = {

      {
        name = "C/C++: Launch",

        type = "codelldb",

        request = "launch",

        program = function()
          return vim.fn.input(
            "Path to executable: ",
            vim.fn.getcwd() .. "/",
            "file"
          )
        end,

        cwd = "${workspaceFolder}",

        stopOnEntry = false,

        args = {},

        console = "integratedTerminal",

      },

      {
        name = "C/C++: Launch with arguments",

        type = "codelldb",

        request = "launch",

        program = function()
          return vim.fn.input(
            "Path to executable: ",
            vim.fn.getcwd() .. "/",
            "file"
          )
        end,

        cwd = "${workspaceFolder}",

        stopOnEntry = false,

        args = function()
          local args_string = vim.fn.input("Arguments: ")

          return vim.split(args_string, " ", {
            trimempty = true,
          })
        end,

        console = "integratedTerminal",

      },

    }


    dap.configurations.c = cpp_config
    dap.configurations.cpp = cpp_config


    -- ========================================================================
    -- BREAKPOINT SIGNS
    -- ========================================================================

    vim.fn.sign_define("DapBreakpoint", {
      text = "●",
      texthl = "DiagnosticSignError",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapBreakpointCondition", {
      text = "◆",
      texthl = "DiagnosticSignWarn",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapBreakpointRejected", {
      text = "○",
      texthl = "DiagnosticSignError",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapStopped", {
      text = "▶",
      texthl = "DiagnosticSignWarn",
      linehl = "Visual",
      numhl = "DiagnosticSignWarn",
    })

    vim.fn.sign_define("DapLogPoint", {
      text = "◆",
      texthl = "DiagnosticSignInfo",
      linehl = "",
      numhl = "",
    })


    -- ========================================================================
    -- AUTOMATIC UI
    -- ========================================================================

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end


    -- ========================================================================
    -- KEYMAPS
    -- ========================================================================

    local opts = {
      noremap = true,
      silent = true,
    }


    -- ------------------------------------------------------------------------
    -- Breakpoint
    -- ------------------------------------------------------------------------

    vim.keymap.set("n", "<leader>db", function()
      dap.toggle_breakpoint()
    end, {
      desc = "DAP: Toggle breakpoint",
      unpack(opts),
    })


    -- Conditional breakpoint
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(
        vim.fn.input("Breakpoint condition: ")
      )
    end, {
      desc = "DAP: Conditional breakpoint",
      unpack(opts),
    })


    -- Log point
    vim.keymap.set("n", "<leader>dl", function()
      dap.set_breakpoint(
        nil,
        nil,
        vim.fn.input("Log message: ")
      )
    end, {
      desc = "DAP: Log point",
      unpack(opts),
    })


    -- ------------------------------------------------------------------------
    -- Execution
    -- ------------------------------------------------------------------------

    vim.keymap.set("n", "<leader>dc", function()
      dap.continue()
    end, {
      desc = "DAP: Continue",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>dp", function()
      dap.pause()
    end, {
      desc = "DAP: Pause",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>dr", function()
      dap.restart()
    end, {
      desc = "DAP: Restart",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>dq", function()
      dap.terminate()
    end, {
      desc = "DAP: Terminate",
      unpack(opts),
    })


    -- ------------------------------------------------------------------------
    -- Stepping
    -- ------------------------------------------------------------------------

    vim.keymap.set("n", "<leader>do", function()
      dap.step_over()
    end, {
      desc = "DAP: Step over",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>di", function()
      dap.step_into()
    end, {
      desc = "DAP: Step into",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>dO", function()
      dap.step_out()
    end, {
      desc = "DAP: Step out",
      unpack(opts),
    })


    -- ------------------------------------------------------------------------
    -- UI
    -- ------------------------------------------------------------------------

    vim.keymap.set("n", "<leader>du", function()
      dapui.toggle()
    end, {
      desc = "DAP: Toggle UI",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>de", function()
      dapui.eval()
    end, {
      desc = "DAP: Evaluate expression",
      unpack(opts),
    })


    vim.keymap.set("n", "<leader>dt", function()
      dapui.float_element()
    end, {
      desc = "DAP: Float element",
      unpack(opts),
    })


    -- ------------------------------------------------------------------------
    -- REPL
    -- ------------------------------------------------------------------------

    vim.keymap.set("n", "<leader>dh", function()
      dap.repl.open()
    end, {
      desc = "DAP: Open REPL",
      unpack(opts),
    })


    -- ========================================================================
    -- F-KEYS
    -- ========================================================================

    vim.keymap.set("n", "<F5>", dap.continue, {
      desc = "DAP: Continue",
    })

    vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, {
      desc = "DAP: Toggle breakpoint",
    })

    vim.keymap.set("n", "<F10>", dap.step_over, {
      desc = "DAP: Step over",
    })

    vim.keymap.set("n", "<F11>", dap.step_into, {
      desc = "DAP: Step into",
    })

    vim.keymap.set("n", "<F12>", dap.step_out, {
      desc = "DAP: Step out",
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
-- Buffer tabline + Bdelete keymap
-- ----------------------------------------------------------------------------
require("bufferline").setup({
  options = {
    persist_buffer_sort = true,
    hover = {
      enabled = true,
      delay = 200,
      reveal = { "close" },
    },
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      },
    },
  },
})

vim.keymap.set("n", "<A-Left>", "<cmd>BufferLineCyclePrev<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-Right>", "<cmd>BufferLineCycleNext<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", "<cmd>BufferLineCyclePrev<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<cmd>BufferLineCycleNext<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", "<cmd>Bdelete<cr>", { noremap = true, silent = true })

-- ----------------------------------------------------------------------------
-- Notes (updated: CocInstall -> Mason, PlugInstall -> Lazy)
-- ----------------------------------------------------------------------------
-- :Lazy clean / :Lazy install / :Lazy update   (was :PlugClean :PlugInstall :UpdateRemotePlugins)
--
-- :Mason                       -- opens UI to install/manage LSP servers
-- clangd  -> installed via mason-lspconfig ensure_installed above
-- pyright -> installed via mason-lspconfig ensure_installed above
-- (coc-snippets equivalent: LuaSnip, not added here — say the word if you want it)
--
-- Debugging (nvim-dap):
--   Python:
--     python3 -m pip install debugpy
--
--   C/C++:
--     :MasonInstall codelldb
--
--   Main controls:
--     <leader>db / <F9>   toggle breakpoint
--     <leader>dc / <F5>   continue / start
--     <leader>dp          pause
--     <leader>dr          restart
--     <leader>dq          terminate session
--     <leader>do / <F10>  step over
--     <leader>di / <F11>  step into
--     <leader>dO / <F12>  step out
--     <leader>du          toggle DAP UI
--     <leader>de          evaluate expression
--     <leader>dh          open DAP REPL
--
--   DAP UI layout:
--     left   = Scopes / Breakpoints / Stacks / Watches
--     bottom = REPL / Console

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

-- ----------------------------------------------------------------------------
-- Colorscheme — activate one of your installed themes
-- ----------------------------------------------------------------------------
vim.o.termguicolors = true
pcall(vim.cmd, "colorscheme dracula")
-- Alternatives, just swap the line above:
--   pcall(vim.cmd, "colorscheme onedark")
--   pcall(vim.cmd, "colorscheme palenight")
--   pcall(vim.cmd, "colorscheme one")