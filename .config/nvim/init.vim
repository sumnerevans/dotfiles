" Cool other configs to look at
" - http://www.lukesmith.xyz/conf/.vimrc
" - https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
" - https://github.com/jschomay/.vim/blob/master/vimrc
" - https://github.com/jhgarner/DotFiles

" PLUG: https://github.com/junegunn/vim-plug =================================
call plug#begin('~/.local/share/nvim/plugged')

" Colors
Plug 'lanox/lanox-vim-theme'            " Colorscheme
Plug 'luochen1990/rainbow'              " Color pairs of parentheses

" Language Support
Plug 'sheerun/vim-polyglot'             " Supports all of the languages

" UI
Plug 'airblade/vim-gitgutter'           " Git integration in the gutter
Plug 'ctrlpvim/ctrlp.vim'               " Fuzzy finder
Plug 'jistr/vim-nerdtree-tabs'          " File tree compatibilty with tabs
Plug 'scrooloose/nerdtree'              " File tree
Plug 'vim-airline/vim-airline'          " Cooler status bar
Plug 'vim-airline/vim-airline-themes'   " Status bar themes
Plug 'Xuyuanp/nerdtree-git-plugin'      " Git integration for NERDTree

" Editing
Plug 'alvan/vim-closetag'               " Automatically close HTML tags
Plug 'aperezdc/vim-template'            " Templates for various types of files
Plug 'ervandew/supertab'                " Use tab for autocomplete
Plug 'terryma/vim-multiple-cursors'     " Allow multiple cursors
Plug 'tpope/vim-commentary'             " Easy commenting of lines
Plug 'jiangmiao/auto-pairs'             " Automatically close parentheses, etc.
Plug 'vim-scripts/a.vim'                " Switch between .h and .cpp files

" Code Completion
Plug 'autozimu/LanguageClient-neovim',  " Language Server Protocol
            \{ 'do': ':UpdateRemotePlugins' }
" Plug 'roxma/ncm-clang'                  " Code completion for C++
Plug 'roxma/nvim-completion-manager'    " Code completion Manager

" Linting
Plug 'w0rp/ale'                         " Linter

call plug#end()

" VARIABLES
let s:os = system('uname -s')
let $PLUGIN_CONFIG_ROOT = '$HOME/.config/nvim/plugin_configs'

" COLOR SCHEME ===============================================================
colorscheme lanox
highlight LineNr ctermfg=grey
highlight SpellBad ctermbg=160 ctermfg=white
highlight SpellRare ctermfg=234
highlight SpellLocal ctermfg=234
highlight SpellCap ctermfg=234
highlight ColorColumn ctermbg=8 guibg=#303030
highlight Visual ctermbg=67 ctermfg=231

" Highlight past 100 characters
highlight Over100Length ctermbg=red ctermfg=white guibg=#BD4F4F
match Over100Length /\%101v.\+/

" UI =========================================================================
set colorcolumn=80,100,120                  " Column guides
set mouse=a                                 " Enable mouse scrolling
set number                                  " Show the current line number
set signcolumn=yes                          " Always show the sign column for git gutter
set title                                   " Override the terminal title
set list listchars=tab:\▶\ ,trail:␣,nbsp:␣  " Highlight unwanted whitespace

" PLUGIN CONFIGURATIONS ======================================================
" Airline - Status bar
let g:airline_powerline_fonts = 1                   " Enable fancy chars

" ALE - Linting
let g:ale_open_list = 1                 " Use the location list for ALE
let g:ale_list_window_size = 5          " Limit the size of the ALE output to 5 lines
let g:ale_sign_error = '✖'              " Consistent sign column with Language Client
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = '➤'
let g:ale_linters = {
            \ 'python': ['pyls'],
            \ 'rust': ['rls'],
            \}
let g:ale_fixers = {
            \ 'cpp': ['clang-format'],
            \ 'css': ['stylelint'],
            \ 'javascript': ['eslint', 'standard'],
            \ 'jsx': ['eslint'],
            \ 'python': ['isort', 'yapf'],
            \ 'rust': ['rustfmt']
            \}
let g:ale_tex_chktex_options = '-I -n18 -n44'
noremap <C-S-F> :ALEFix<CR>

" CTRLP - Fuzzy finder
" Ignore files ignored by git
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['Makefile']

" Language Client - Handling autocomplete for many languages
set omnifunc=LanguageClient#complete    " Use LanguageClient as the completion engine
let g:LanguageClient_autoStart = 1      " Automatically start language servers.
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['clangd'],
    \ 'javascript': ['/usr/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['/usr/bin/javascript-typescript-stdio'],
    \ 'python': ['pyls'],
    \ 'rust': ['rls'],
\ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> <F12> :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F6> :call LanguageClient_textDocument_rename()<CR>

" NERD Tree
let g:NERDTreeIndicatorMapCustom = {
            \'Modified': '✹', 'Staged': '✚', 'Untracked': '✭', 'Renamed': '➜', 'Unmerged': '═',
            \'Deleted': '✖', 'Dirty': '✗', 'Clean': '✔︎', 'Unknown': '?' }
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = [
            \'.git$[[dir]]',
            \'.sass-cache$[[dir]]', '__pycache__$[[dir]]', '.pyc',
            \'.nyc_output$[[dir]]', '.tmp$[[dir]]', '.ropeproject$[[dir]]',
            \'.bk$[[file]]', '.out$[[file]]', '.aux$[[file]]', '.log$[[file]]', '_minted-*',
            \'.gz$[[file]]', '.fls$[[file]]', '.fdb_latexmk$[[file]]',
            \]
let g:NERDTreeWinSize = 30
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_synchronize_view = 0
map <S-T> <plug>NERDTreeTabsToggle<CR>

" Rainbow - Parentheses coloring
let g:rainbow_active = 1                " Enable the parentheses coloring
source $PLUGIN_CONFIG_ROOT/rainbow.vim  " Configuration for rainbow

" Supertab - Use tab for autocomplete
let g:SuperTabDefaultCompletionType = '<c-n>'   " Pressing tab goes down the
                                                " list

" Vim Templates - Templates for various filetypes
let g:templates_directory = '~/.vim/vim-templates'  " Custom templates

" TABS AND BUFFERS ===========================================================
" Editor Tabs
set showtabline=2 " always show the tab bar
map <c-h> :tabp<CR>
map <c-l> :tabn<CR>
map <c-t> :tabnew<CR>

" Navigation between buffers in tab
set splitbelow          " Split below, rather than above
set splitright          " Split to the right, rather than the left
map <A-k> <C-W><C-K>
map <A-j> <C-W><C-J>
map <A-h> <C-W><C-H>
map <A-l> <C-W><C-L>

" EDITING ====================================================================
set hidden                  " Don't close when switching buffers
set scrolloff=5             " Always have 5 lines above/below the current line
set virtualedit=onemore     " Allow the cursor to go one past the EOL
set pastetoggle=<F2>        " Make C-S-V paste work better

" Tabs
set shiftwidth=4            " 4 is the only way
set expandtab               " Insert spaces instead of tabs

" Shortcuts for the things I type a lot in insert mode
source $HOME/.vim/shortcuts

" Make j and k behave nicer when the line wraps
noremap j gj
noremap k gk

" Make Vim the use the system clipboard
if s:os ==# "Linux\n"
    set clipboard+=unnamedplus
else
    set clipboard+=unnamed
endif

" Commenting
noremap <F8> :Commentary<CR>

" Run make
nnoremap <F5> :make<CR>
nnoremap <S-F5> :make run<CR>

" Clean up paragraph
noremap <C-c> vipgq<CR>

" Search
set ignorecase  " ignore case...
set smartcase   " unless the search string has uppercase letters

" Undo and Swap (~/tmp is a tmpfs, so writing to it does not use disk)
set undofile                    " Use an undo file
set undodir=~/tmp/nvim/undo//   " Store undo files in ~/tmp to avoid disk I/O
set directory=~/tmp/nvim/swap// " Store swap files in ~/tmp to aviod disk I/O

" FILETYPE SPECIFIC CONFIGURATIONS ===========================================
" Automatically break lines at 80 characters on TeX/LaTeX, Markdown, and text
" files
" Enable spell check on TeX/LaTeX, Markdown, and text files
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal tw=80
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst setlocal spell spelllang=en_gb
autocmd BufRead *.tex,*.md,*.txt,*.rst match Over100Length /\%81v.\+/

" Automatically break lines at 100 characters when writing HTML files
" Enable spell check on HTML files
autocmd BufNewFile,BufRead *.html setlocal tw=100
autocmd BufNewFile,BufRead *.html setlocal spell spelllang=en_gb

" Automatically break lines at 80 characters when writing emails in mutt
" Enable spell check for emails in mutt and quotes file
autocmd BufRead $HOME/tmp/mutt-*,$HOME/.mutt/quotes setlocal tw=72
autocmd BufRead $HOME/tmp/mutt-*,$HOME/.mutt/quotes setlocal spell spelllang=en_gb
autocmd BufRead $HOME/tmp/mutt-*,$HOME/.mutt/quotes setlocal colorcolumn=72,80
autocmd BufRead $HOME/tmp/mutt-*,$HOME/.mutt/quotes match Over100Length /\%73v.\+/

" Use TAB = 2 spaces for a few file types
autocmd FileType javascript,xhtml,html,scss,yaml,css,markdown set shiftwidth=2
