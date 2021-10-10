call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " autocomplete, prettier, eslint
let g:coc_global_extensions = ['coc-tsserver', 'coc-html', 'coc-json', 'coc-prettier']  " list of CoC extensions needed

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

Plug 'jiangmiao/auto-pairs' " auto close ( [ {

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" FZF for fuzzy finding files and text
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Prettier on save setup
Plug 'sbdchd/neoformat'

" Typescript react support
Plug 'ianks/vim-tsx'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

call plug#end()

" Use system clipboard
set clipboard+=unnamedplus

" Color scheme
colorscheme gruvbox

" Nerdtree keymap
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap fn :NERDTreeFind<CR>

" Use spaces instead of tabs
set expandtab

" Aliases to go to next and previous eslint error
nmap <silent> ]] :ALENext<cr>
nmap <silent> [[ :ALEPrevious<cr>

" Alias file history command
nnoremap [o :History<cr>

autocmd FileType css CocDisable
autocmd FileType ts,js,tsx,jsx CocEnable

set number
