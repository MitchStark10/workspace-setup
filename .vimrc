set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"Plugins ---------------------------------------
Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-commentary'
Plugin 'gko/vim-coloresque'
Plugin 'vim-airline/vim-airline'
Plugin 'preservim/nerdcommenter'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'tpope/vim-fugitive'
Plugin 'vimpostor/vim-lumen'
Plugin 'github/copilot.vim'
Plugin 'DanBradbury/copilot-chat.vim'
Plugin 'junegunn/vim-easy-align'

" JS
Plugin 'pangloss/vim-javascript'
" Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'prisma/vim-prisma'

" Python
Plugin 'andviro/flake8-vim'
call vundle#end()
filetype plugin indent on

"Quiet terminal noises
set visualbell
set t_vb=

"Formatting--------------------------------------
set tabstop=2
set shiftwidth=2
set expandtab
syntax on
set backspace=2
set number
set mouse=a

" WSL yank support
set clipboard=unnamed
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

"Search defaults
set is hls

let g:coc_global_extensions = [
  \'coc-tsserver',
  \'coc-eslint',
  \'coc-prettier',
  \'coc-json', 
\]

try
  nnoremap <silent> ]a :CocDiagnostics<CR>
  nnoremap <silent> ]] :call CocAction('diagnosticNext')<cr>
  nnoremap <silent> [[ :call CocAction('diagnosticPrevious')<cr>
endtry


"Wild menu----------------------------------
set wildmenu
set wildmode=list:longest,full
set ignorecase
set smartcase

"Searching----------------------------------
let g:fzf_history_dir = '~/.local/share/fzf-history'


"Nerdtree------------------------------------
nmap <C-n> :NERDTreeToggle<CR>
nnoremap <C-b> :Buffers<CR>
let g:NERDTeeIgnore = ['^node_modules$']
let NERDTreeShowHidden=1

"autocomplete--------------------------------
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


"NERDCommenter----------------------------------------
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" Fix for a git gutter issue that occasionally happens
let g:gitgutter_realtime = 0

filetype plugin on

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-@> coc#refresh()

"Windows cursor issue fix
if &term =~ '^xterm'
  " solid underscore
  let &t_SI .= "\<Esc>[4 q"
  " solid block
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif

"Coc.nvim code action setup
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
set encoding=utf-8

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

call coc#config('list', { 'maxPreviewHeight': 30 })

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
nnoremap K :call CocActionAsync('doHover')<CR>

" Setup organize imports on write
command! OR call CocAction('runCommand', 'editor.action.organizeImport')
" autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx :OR

" Symbol renaming
nmap <space>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <space>a  <Plug>(coc-codeaction-selected)
nmap <space>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <space>ca  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <space>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <space>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"Airline customization
let g:airline_section_x = ""
let g:airline_section_y = ""

"General Aliases---------------------------------
nmap [o :History<CR>
nmap fn :NERDTreeFind<CR>
nmap ff :Prettier<CR>
nmap tn :tabn<CR>
nmap tp :tabp<CR>
nmap fb /<c-r>+<CR>
nnoremap <C-s> :w<CR>
vmap <c-_> \c<space><CR>
nmap <c-_> \c<space><CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nmap <c-p> :FZF<CR>

" Workaround for searching hidden folders
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, "--hidden", fzf#vim#with_preview(), <bang>0)
nmap <c-f> :Ag<CR>

nnoremap <c-k> :redr!<CR>
command! DiffOrig rightbelow vertical new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! T terminal
command CC CopilotChatOpen

" Color scheme handling
command! Light set background=light
command! Dark set background=dark
command! CloseBuffers %bd|e#
colorscheme PaperColor
au User LumenLight :Light
au User LumenDark :Dark

command! Gblame 0,3Git blame

if system("powershell.exe Get-ItemProperty -Path
    \ \" HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize\"
    \ -Name AppsUseLightTheme | grep AppsUse | awk '{ print $3 }'") == 0
   :Dark
   set background=dark
else
   set background=light
endif

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

command! BufOnly %bd|e#

"flake 8 setup
let g:PyFlakeMaxLineLength = 120
let g:PyFlakeDisabledMessages = 'E201,E202,E203,E221,E231,E241,E251,E272,W503,E702,E741'

noremap! <C-j> <Esc>
vnoremap <C-j> <Esc>
noremap! <C-g> <Esc>
inoremap <C-p> "+gP
nnoremap <C-i> <C-w>

" Weird timeout issue on mac
set re=0
