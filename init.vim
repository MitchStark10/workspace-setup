call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " autocomplete, prettier, eslint
let g:coc_global_extensions = ['coc-html', 'coc-json', 'coc-eslint', 'coc-tsserver']  " list of CoC extensions needed

" Get linter setup
Plug 'w0rp/ale'
let g:ale_fixers = {
 \ 'javascript': ['eslint', 'prettier'],
 \ 'typescript': ['eslint', 'prettier'],
 \ }
let g:ale_linters = {'javascript': ['eslint', 'prettier'], 'typescript': ['eslint', 'prettier']}
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}

" Disable ALE on JSON files
let g:ale_pattern_options = {'\.json$': {'ale_enabled': 0}}


Plug 'jiangmiao/auto-pairs' " auto close ( [ {

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" FZF for fuzzy finding files and text
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Typescript react support
Plug 'ianks/vim-tsx'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'tpope/vim-fugitive'

" LSP Support
" NOTE: <space>ca in normal mode will trigger a prompt for code actions
" available. This can be used for auto importing
Plug 'neovim/nvim-lspconfig', {'do': 'npm i -g typescript-language-server diagnostic-languageserver'}

" \cc is how to block comment
Plug 'preservim/nerdcommenter'

call plug#end()

" Use system clipboard
set clipboard+=unnamedplus

" Color scheme
colorscheme gruvbox

" Nerdtree keymap
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap tt :NERDTreeToggle<CR>
nnoremap fn :NERDTreeFind<CR>

" Nerdcommenter
 nnoremap <leader>cc :NERDCommenterToggle<CR>

" Use spaces instead of tabs
set expandtab

" Aliases to go to next and previous eslint error
nmap <silent> ]] :ALENext<cr>
nmap <silent> [[ :ALEPrevious<cr>


nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :Ag<CR>

" Alias file history command
nnoremap [o :History<cr>

autocmd FileType css,json CocDisable
autocmd FileType ts,js,tsx,jsx CocEnable

set number

set tabstop=4
set shiftwidth=4

" force searches to ignore .gitignore files but find files that start with .
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

" Prettier config
" These are disabled becuase they can be painful with ale, so just run it
" manually with <ff>
" let g:prettier#autoformat = 1
" let g:prettier#autoformat_require_pragma = 0
" let g:prettier#config#single_quote = 'true'
nnoremap ff :Prettier<CR>

lua << EOF
local nvim_lsp = require("lspconfig")
local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end
vim.lsp.handlers["textDocument/formatting"] = format_async
_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', 'l[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', 'l]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}
local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}
EOF
