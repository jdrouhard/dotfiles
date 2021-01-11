"-------------------------------------------------------------------------------
" vim-plug
"-------------------------------------------------------------------------------
let s:plugin_dir = '~/.vim/plugged'
let s:plug_file = '~/.vim/autoload/plug.vim'

if empty(glob(s:plug_file))
    silent execute '!curl -fLo ' . s:plug_file . ' --create-dirs -k ' .
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:polyglot_disabled = ['c/c++']

call plug#begin(s:plugin_dir)

Plug 'airblade/vim-gitgutter'
Plug 'bluz71/vim-moonfly-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'antoinemadec/coc-fzf'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': './install --bin' } | Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'mhartington/oceanic-next'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-dispatch' | Plug 'radenling/vim-dispatch-neovim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
if has("nvim")
    Plug 'sakhnik/nvim-gdb', { 'do': ':UpdateRemotePlugins' }
    if has("nvim-0.5.0")
        Plug 'nvim-treesitter/nvim-treesitter'
        Plug 'nvim-treesitter/playground'
    endif
endif

call plug#end()

if has("nvim-0.5.0")
    lua require'treesitter_config'
endif


"-------------------------------------------------------------------------------
" Text formatting
"-------------------------------------------------------------------------------
set encoding=utf-8

set autoindent                       " always set autoindenting on
set expandtab                        " insert spaces when the tab key is pressed
set shiftround                       " use multiple of shiftwidth when indenting
                                     " with '<' and '>'
set shiftwidth=4                     " number of spaces to use for autoindenting
set smarttab                         " insert tabs on the start of a line
                                     " according to shiftwidth, not tabstop
set tabstop=4                        " a tab is four spaces
set wrap                             " wrap overlong lines

"-------------------------------------------------------------------------------
" UI settings
"-------------------------------------------------------------------------------

set background=dark
if (has("termguicolors") && (has("nvim") || v:version >= 800 || has("patch1942")) || has("gui_running"))
    set termguicolors
    let g:onedark_terminal_italics=1
    let g:gruvbox_italic=1
    let g:gruvbox_contrast_dark='soft'
    let g:oceanic_next_terminal_italic=1
    let g:oceanic_next_terminal_bold=1
    "let g:airline_theme='gruvbox'
    "colorscheme gruvbox
    "let g:airline_theme='oceanicnext'
    "colorscheme OceanicNext
    let g:airline_theme='nightfly'
    colorscheme nightfly

    call toggletheme#maptruecolors("<F12>")
else
    let g:base16_termtrans=1
    let g:base16_term_italics=1
    let g:airline_theme='solarized'
    colorscheme base16

    call toggletheme#maptransparency("<F10>")
    call toggletheme#mapbg("<F11>")
    call toggletheme#map256("<F12>")
endif

if !has("nvim")
    set t_so=[7m                         " set escape codes for standout mode
    set t_se=[27m                        " set escape codes for standout mode
    set t_ZH=[3m                         " set escape codes for italics mode
    set t_ZR=[23m                        " set escape codes for italics mode
    if has("termguicolors")
        let &t_8f = "\<esc>[38;2;%lu;%lu;%lum" " true color fix
        let &t_8b = "\<esc>[48;2;%lu;%lu;%lum" " true color fix
    endif
endif

set noshowmode   " Hide the default mode text (e.g. -- INSERT -- below the status line)
"let g:airline_powerline_fonts=1
let g:solarized_base16=1
let g:airline_solarized_normal_green=1

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#buffer_nr_format='%s '
"let g:airline#extensions#tabline#fnamemod=':t'
function! GetTagname()
    if has("nvim-0.5.0")
        let disp = nvim_treesitter#statusline(90)
        if disp != v:null && disp != ''
            return disp
        endif
    endif
    silent! return Tlist_Get_Tagname_By_Line()
endfunction
call airline#parts#define_function("cfunc", "GetTagname")
let g:airline_section_x = airline#section#create_right(["cfunc", "filetype"])

set backspace=indent,eol,start       " allow backspacing over everything in
                                     " insert mode
set nofoldenable                     " disable code folding by default
set number                           " always show line numbers
set numberwidth=5                    " we are good for up to 99999 lines
set showcmd                          " display incomplete commands
set modeline                         " enable modeline identifiers in files
set cmdheight=2                      " set cmdheight=2 to avoid pesky
                                     " "Press ENTER to continue" after errors
set lazyredraw

"-------------------------------------------------------------------------------
" Visual cues
"-------------------------------------------------------------------------------

set incsearch                        " show search matches as you type
set listchars=tab:▸\ ,trail:·        " set custom characters for non-printable
                                     " characters
set list                             " always show non-printable characters
set matchtime=3                      " set brace match time
set scrolloff=3                      " maintain more context around the cursor
set linebreak                        " wrap lines at logical word boundaries
set showbreak=↪                      " character to display in front of wrapper
                                     " lines
set showmatch                        " enable brace highlighting
set ignorecase                       " ignore case
set smartcase                        " ignore case if search pattern is all
                                     " lowercase, case-sensitive otherwise
set visualbell                       " only show a visual cue when an error
                                     " occurs
set laststatus=2                     " always show the status line

if exists('&breakindent')
    set breakindent                  " indent wrapped lines
endif

if exists('&signcolumn')
    set signcolumn=yes               " always show the sign column
else
    let g:gitgutter_sign_column_always = 1
endif

"-------------------------------------------------------------------------------
" Behavioural settings
"-------------------------------------------------------------------------------

set autoread                            " automatically reload a file when it has
                                        " been changed
if has("nvim")
    "set shada^=%                        " Remember info about open buffers on close
    set inccommand=nosplit              " Don't show partial results in preview window
else
    "set viminfo^=%                      " Remember info about open buffers on close
    set undodir=$HOME/.vim/undo         " persistent undo directory
    set dir=$HOME/.vim/swap             " set the swap directory
endif

set backup                              " enable backups
set backupdir=$HOME/.vim/backup         " only save backups to this directory
set undofile                            " enable persistent undo
"set clipboard=unnamedplus              " use the system clipboard by default
set hidden                              " be able to put the current buffer to the
                                        " background without writing to disk and
                                        " remember marks and undo-history when a
                                        " background buffer becomes current again
"set history=50                          " keep 50 lines of command line history
set nostartofline                       " do not change the X position of the
                                        " cursor when paging up and down
set wildignore+=*.o,*.obj,*.dwo
set path=$PWD/**
set ttimeoutlen=0                       " don't wait for key codes (<ESC> is instant)
set updatetime=100

set completeopt=longest,menuone         " Configure (keyword) completion.
set shortmess+=c

"-------------------------------------------------------------------------------
" Key remappings
"-------------------------------------------------------------------------------

let mapleader=" "                    " set our personal modifier key to space

" Quickly edit and reload the vimrc file.
nmap <silent> <leader>ev :e $MYVIMRC<CR>
"nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Map Y to copy to the end of the line (which is more logical, also according
" to the Vim manual.
map Y y$

vnoremap < <gv
vnoremap > >gv

nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>

nnoremap / /\v
vnoremap / /\v

" Close the current buffer
map <leader>bd :Bclose<CR>
map <C-q> :Bclose<CR>

" Remap Q to do nothing instead of entering ex mode.
nnoremap Q <nop>

" Remap <leader>m to execute a make.
nmap <silent> <leader>m :make<CR>

" Remap Ctrl-k and Ctrl-j to jump to the previous and next compiler error
" respectively.
nmap <silent> <C-k> :cp<CR>
nmap <silent> <C-j> :cn<CR>

" Split window into .h and .cpp using F3
"map <F3> :AS<CR>
" Switch between .h and .cpp using F4.
map <F4> :A<CR>
" Switch between .h and _inline.h using F5.
map <F5> :AI<CR>

" Easier escape (jk is so rarely typed this shouldn't be an issue)
inoremap jk <ESC>

" Movement
nnoremap j gj
nnoremap k gk

" Configure fzf mappings
nnoremap          <leader>s   :Ag<space>
nnoremap <silent> <leader>ag  :Ag <C-R><C-W><CR>
nnoremap <silent> <leader>AG  :Ag <C-R><C-A><CR>
xnoremap <silent> <leader>ag  y:Ag <C-R>"<CR>

nnoremap <silent> <C-p>       :Files<CR>
nnoremap <silent> <leader>l   :Buffer<CR>
nnoremap <silent> <leader>t   :GFiles<CR>
nnoremap <silent> <leader>h   :Commands<CR>
nnoremap <silent> <leader>?   :Helptags<CR>
nnoremap <silent> <leader>gs  :GFiles?<CR>
nnoremap <silent> <leader>gl  :Commits<CR>
nnoremap <silent> <leader>gbl :BCommits<CR>

imap <C-x><C-f> <plug>(fzf-complete-path)
imap <C-x><C-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" coc.nvim mappings
nmap <silent> <leader>jd <plug>(coc-definition)
nmap <silent> <F3>       <plug>(coc-references)
nmap <silent> K          :call CocActionAsync('doHover')<CR>
nmap <silent> <leader>ac :CocAction<CR>

xmap if <plug>(coc-funcobj-i)
omap if <plug>(coc-funcobj-i)
xmap ic <plug>(coc-classobj-i)
omap ic <plug>(coc-classobj-i)

" vim-fugitive mappings
nnoremap <silent> <leader>gg :Gblame<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>

" vim-easy-align mappings
xmap ga <plug>(EasyAlign)
nmap ga <plug>(EasyAlign)

" Miscellaneous
map <leader>w <C-w>
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

"-------------------------------------------------------------------------------
" Configure plugins
"-------------------------------------------------------------------------------
" Configure "A" plugin
" Never open a non-existing file
let g:alternateNoDefaultAlternate = 1

" Configure fzf
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
if has('nvim') || has('gui_running')
    let $FZF_DEFAULT_OPTS .= ' --inline-info --bind up:preview-up,down:preview-down,pgup:preview-page-up,pgdn:preview-page-down'
endif

let g:fzf_layout = { 'window': {'width': 0.9, 'height': 0.6 }, 'down': '~15%' }
let g:fzf_commits_log_options = '--graph --color=always --all --pretty=tformat:"%C(auto)%h%d %s %C(green)(%ar)%Creset %C(blue)<%an>%Creset"'

" Configure taglist
let Tlist_Inc_Winwidth=0
let Tlist_Process_File_Always=1
let Tlist_Use_Horiz_Window=0
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth=60
let Tlist_Exit_OnlyWindow=1
let Tlist_Close_On_Select=0

if has("nvim")
    " Configure nvim-gdb
    let g:nvimgdb_config_override = {
        \ 'key_frameup':    '<c-k>',
        \ 'key_framedown':  '<c-j>',
        \ }
endif

"-------------------------------------------------------------------------------
" Configure autocommmands
"-------------------------------------------------------------------------------

command! -range=% StripTrailingWhitespace <line1>,<line2>s/\s\+$//e | norm! ``

augroup vimrc_autocmd
    autocmd!
    " Modify default tabstop and textwidth/formatting
    au FileType cmake,xml setlocal tabstop=2
    au FileType cmake,xml setlocal shiftwidth=2

    au FileType cpp,python setlocal textwidth=90
    au FileType cpp,python setlocal formatoptions=crqnj

    " Strip trailing white spaces in source code.
    "au BufWritePre *.cpp,*.hpp,*.h,*.c exe "norm! m`" | :StripTrailingWhitespace
    au BufWritePre .vimrc,*.js,*.php exe "norm! m`" | :StripTrailingWhitespace

    " Add support for Doxygen comment leader.
    au FileType h,hpp,cpp,c setlocal comments^=:///

    " Override vim-polyglot changes to git commit formatting
    au FileType gitcommit setlocal formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s*
    au FileType gitcommit setlocal formatoptions+=n

    " sqli files are actually sql files
    au BufRead,BufNewFile *.sqli setlocal filetype=sql

    " Override vim-polyglot filetype detection of spec files
    au BufRead,BufNewFile *.spec setlocal filetype=spec
    au BufRead,BufNewFile *.inc setlocal filetype=cpp

    " Resize splits when the window is resized.
    au VimResized * exe "normal! \<c-w>="

    " Return to last edit position when opening files (You want this!)
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                 \ |   exe "normal! g`\""
                 \ | endif

    " Add preview functionality to fzf
    au VimEnter * command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    au VimEnter * command! -bang -nargs=* Ag
                \ call fzf#vim#ag(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview('up:60%')
                \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
                \                 <bang>0)

augroup END

"-------------------------------------------------------------------------------
" Misc settings
"-------------------------------------------------------------------------------
if has("nvim")
    function! AS_HandleSwapfile(filename, swapname)
        " if swapfile is older than file itself, just get rid of it
        if getftime(a:swapname) < getftime(a:filename)
            call delete(a:swapname)
            let v:swapchoice = 'e'
        endif
    endfunction

    augroup AutoSwap
        autocmd!
        autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
                \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
        autocmd SwapExists * call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
    augroup END
else
    " Always start editing a file in case a swap file exists.
    augroup AutoSwap
        autocmd!
        autocmd SwapExists * let v:swapchoice = 'e'
    augroup END
endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Read local machine settings
if filereadable(expand("~/.localvimrc"))
    so ~/.localvimrc
endif

" Read in a custom Vim configuration local to the working directory.
if filereadable(".project.vim")
    so .project.vim
endif

