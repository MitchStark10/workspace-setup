"==============================================================================
" => General
"==============================================================================
" Set the leader key to space
let mapleader = " "

" Map ctrl+j to escape
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>

nnoremap <C-i> <C-w>

" Enable syntax highlighting
syntax on

" Enable filetype detection and plugins
filetype plugin indent on

" Set encoding to UTF-8
set encoding=utf-8

" Set line numbers
set number

" Highlight current line
set cursorline

" Enable mouse support
set mouse=a

" Case insensitive
set ignorecase

" Enable intelligent tab detection
set tabstop=2
set shiftwidth=2
set expandtab
syntax on
set backspace=2
set number
set mouse=a

" Detect indentation from file content
autocmd BufReadPost * if !exists('b:editorconfig') | call DetectIndent() | endif

function! DetectIndent()
    let l:sample_lines = min([line('$'), 100])
    let l:spaces = {}

    for l:lnum in range(1, l:sample_lines)
        let l:line = getline(l:lnum)
        let l:indent = matchstr(l:line, '^\s\+')
        if !empty(l:indent) && l:indent[0] == ' '
            let l:count = len(l:indent)
            let l:spaces[l:count] = get(l:spaces, l:count, 0) + 1
        endif
    endfor

    " Find most common indent size
    let l:max_count = 0
    let l:detected = 4
    for [l:size, l:count] in items(l:spaces)
        if l:count > l:max_count
            let l:max_count = l:count
            let l:detected = str2nr(l:size)
        endif
    endfor

    " Set buffer-local settings
    if l:max_count > 0
        execute 'setlocal tabstop=' . l:detected
    else
        setlocal tabstop=4  " Default fallback
    endif
endfunction

" Enable persistent undo
set undofile
set undodir=~/.config/nvim/undodir


" WSL clipboard support
set clipboard=unnamedplus

"==============================================================================
" => Package Manager (vim-plug)
"==============================================================================

" Auto-install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugin list
call plug#begin('~/.local/share/nvim/plugged')

" File explorer
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'seblj/roslyn.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

" Color schemes
Plug 'folke/tokyonight.nvim'

" Prettier formatter
Plug 'prettier/vim-prettier', { 'do': 'npm install --frozen-lockfile --production' }

" GitHub Copilot
Plug 'github/copilot.vim'

" Git integration
Plug 'tpope/vim-fugitive'

" Commenting
Plug 'tpope/vim-commentary'

" Linting
Plug 'mfussenegger/nvim-lint'

call plug#end()

"==============================================================================
" => Plugin Configuration
"==============================================================================

" NERDTree
" Open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>

" Find current file in NERDTree
nnoremap fn :NERDTreeFind<CR>

" FZF
" Enable search history
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Find files with Ctrl+p
map <C-p> :Files<CR>

" Show recent buffers with Ctrl+b
map <C-b> :Buffers<CR>

map <C-f> :Ag<CR>

" Prettier
" Format on save for JS/TS files
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" Format with leader+p
nnoremap <leader>p :Prettier<CR>

" Fugitive (Git)
" Create GBlame command
command! GBlame Git blame

" Commentary
" Map Ctrl+/ to toggle comments in visual mode (Ctrl+/ sends <C-_> in terminals)
vmap <C-_> gc

" LSP and Autocompletion Configuration
lua << EOF
-- LSP config
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']a', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']e', '<cmd>lua vim.diagnostic.setqflist({severity = vim.diagnostic.severity.ERROR})<CR>', opts)
end

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Mason setup
require("mason").setup({
    registries = {
        "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
    }
})
require("mason-lspconfig").setup()

vim.lsp.config("ts_ls", {
  on_attach = on_attach
})
vim.lsp.enable("ts_ls")

vim.lsp.config("pyright", {
  on_attach = on_attach,
  root_dir = function(fname)
    local util = require('lspconfig.util')
    -- Look for common Python project markers
    local root = util.root_pattern('.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt', 'manage.py')(fname)
    return root or vim.fn.getcwd()
  end,
  before_init = function(_, config)
    -- Try to detect virtual environment
    local venv_paths = {
      vim.fn.getcwd() .. '/venv',
      vim.fn.getcwd() .. '/.venv',
      vim.env.VIRTUAL_ENV,
    }

    for _, venv in ipairs(venv_paths) do
      if venv and vim.fn.isdirectory(venv) == 1 then
        config.settings.python.pythonPath = venv .. '/bin/python'
        break
      end
    end
  end,
  settings = {
    python = {
      pythonPath = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or nil,
      analysis = {
        typeCheckingMode = "basic",  -- Use basic instead of strict
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        reportMissingImports = false,
        reportMissingTypeStubs = false,  -- Suppress missing type stubs errors
        reportUnknownMemberType = false,
        reportUnknownArgumentType = false,
        reportUnknownVariableType = false,
        reportUnknownParameterType = false,
        reportGeneralTypeIssues = false,  -- Suppress general type issues
        diagnosticSeverityOverrides = {
          reportOptionalMemberAccess = "none",
          reportOptionalSubscript = "none",
          reportOptionalCall = "none",
        }
      }
    }
  }
})
vim.lsp.enable("pyright")

vim.lsp.config("roslyn", {
  on_attach = on_attach,
  capabilities = capabilities,
})

require('roslyn').setup({})

-- nvim-cmp setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body)

      -- For `luasnip` user.
      -- require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn.UltiSnips_Anon(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

-- Treesitter setup
require('nvim-treesitter.configs').setup({
  ensure_installed = { "javascript", "typescript", "tsx", "c_sharp" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- Treesitter context setup
require('treesitter-context').setup()

-- Theme configuration
local function set_theme()
  -- Check OS theme (for WSL, check Windows theme)
  local handle = io.popen('powershell.exe -Command "(Get-ItemProperty -Path HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize).AppsUseLightTheme" 2>/dev/null')
  if handle then
    local result = handle:read("*a")
    handle:close()

    if result:match("1") then
      vim.o.background = "light"
      vim.cmd("colorscheme tokyonight-day")
    else
      vim.o.background = "dark"
      vim.cmd("colorscheme tokyonight-night")
    end
  else
    -- Fallback to dark theme if detection fails
    vim.o.background = "dark"
    vim.cmd("colorscheme tokyonight-night")
  end
end

-- Set theme on startup
set_theme()

-- Command to manually switch to light mode
vim.api.nvim_create_user_command('Light', function()
  vim.o.background = "light"
  vim.cmd("colorscheme tokyonight-day")
end, {})

-- Command to manually switch to dark mode
vim.api.nvim_create_user_command('Dark', function()
  vim.o.background = "dark"
  vim.cmd("colorscheme tokyonight-night")
end, {})

-- Command to organize and remove unused imports
vim.api.nvim_create_user_command('OR', function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports", "source.removeUnusedImports" } },
    apply = true,
  })
end, {})

-- Command to open terminal
vim.api.nvim_create_user_command('T', function()
  vim.cmd('split | terminal')
  vim.cmd('resize 15')
end, {})

-- nvim-lint configuration
require('lint').linters_by_ft = {
  python = {'flake8'}
}

-- Run linter on save and when entering buffer
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
  pattern = "*.py",
  callback = function()
    require("lint").try_lint()
  end,
})

EOF

"==============================================================================
" => Final Touches
"==============================================================================
" Create undo directory
silent !mkdir -p ~/.config/nvim/undodir
