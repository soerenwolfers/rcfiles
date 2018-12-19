""TODO: Smarter use of ; and TAB
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-surround' 
    Plug 'easymotion/vim-easymotion' "Only use what single character bidirectional search; check kweasy as alternative
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'sillybun/vim-repl', {'do': './install.sh'}
    Plug 'vim-scripts/indentpython.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'romainl/vim-cool'
    Plug 'davidhalter/jedi-vim'
    Plug 'xolox/vim-easytags'
    Plug 'xolox/vim-misc'
    Plug 'lervag/vimtex'
    Plug 'junegunn/vim-easy-align'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-speeddating'
    Plug 'Valloric/YouCompleteMe'
    Plug 'sjl/gundo.vim'
    Plug 'tell-k/vim-autopep8'
    "Try out Plug 'SirVer/ultinsips'
call plug#end()
let g:repl_program = {"python": "ipython --no-autoindent"}
filetype plugin indent on
"filetype on

"""""""" Plugin configuration """"""""
"""" vimtex 
let g:vimtex_view_method = 'zathura'
"""" fzf standard plugin (advanced fzf.vim is installed at the beginning of this script)
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
"""" vimsurround 
let b:surround_indent = 1
"""" easymotion 
hi link EasyMotionTarget Search
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search
hi link EasyMotionShade Comment
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search
"""" YouCompleteMe 
let g:ycm_autoclose_preview_window_after_completion=1
"""" Jedi-vim 
let g:jedi#completions_enabled = 0 " No automatic popup of autocompletion (still available through <C-Space>)
"""" vim-easytags 
autocmd FileType python let b:easytags_auto_highlight = 0

"""""""" Basic options """"""""
set showcmd               " Partial commands
set lazyredraw            " Quick macro application
set noerrorbells          " No annoying sounds
let &t_SI = "\e[6 q"      " Insert mode cursor
let &t_EI = "\e[2 q"      " Normal mode cursor
set timeoutlen=500        " map combination delay
set ttimeoutlen=0         " No delay switching to normal mode (historical reason for delay: escape was escape character, duh)
set clipboard=unnamedplus " Store to system clipboard
set mouse=a               " Mouse to control windows, tabs, and scrolling
set bs=2                  " Activate backspace key
set hidden                " To make :Buffers (see below) work with unsaved buffers, need the following line
set number 
"augroup numbertoggle
    "autocmd!
    "autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    "autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
"augroup END

"""""""" Advanced options """"""""
set completeopt-=preview " Python completion without preview window
set spelllang=en_us      " Spell checking
set hlsearch
set incsearch
"""" Ignore case in search unless search term contains capital letters
"""" Use \c to force case-insensitive, \C to force case-sensitive
set ignorecase
set smartcase
set undodir=$HOME/.vim/undodir " Undo beyond sessions, create undodir manually!
set undofile
let mapleader = " "
set tabstop=4     " Display tabs as 4 spaces
set expandtab     " Replace inserted tabs by spaces
set shiftwidth=4  " Default indent 4 spaces
set nostartofline " Don't move cursor when switching buffers

"""""""" Fix vim stupidity """"""""
"""" Indent commands
nnoremap > >>^
nnoremap < <<^
xnoremap > >gv
xnoremap < <gv
"""" Prevent quickfix window from preventing close of vim
au BufEnter * call QuickFixQuit()
function! QuickFixQuit()
    if &buftype=="quickfix" && winnr('$') < 2
        quit!
    endif
endfunction

"""""""" Mode switches """"""""
"""" Enter visual line mode by vv
xnoremap v V
"""" Leave insert mode 
inoremap jk <Esc>

"""""""" Insert mode """"""""
"""" like x in normal 
imap <C-l> <del> 
"""" Go back one word in insert mode
imap <C-b> <C-o>b
imap <C-f> <C-o>w
"""" Scroll through suggestions (opened with <CTRL-X><...>)
inoremap <C-J> <C-N>
inoremap <C-K> <C-P>

"""""""" Command mode """"""""
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

""""""""" Motions """"""""
noremap - G
"""" Go to next upper letter
onoremap u /\u<CR>
xnoremap u /\u<CR>
"""" Move along displayed lines, not physical lines
noremap gj j
noremap j gj
noremap gk k
noremap k gk
"""" Beginning and end of line and screen
noremap H ^
noremap L $
noremap K H
"""" Between hunks
map ]h <Plug>GitGutterNextHunk
map [h <Plug>GitGutterPrevHunk
"""" Between jumps
nnoremap <C-P> <C-O>
nnoremap <C-N> <C-I>
"""" By letter
map <leader>f <Plug>(easymotion-s)
"""" To definition (I believe this is overwritten by Jedi-vim)
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>/ :Lines<CR>
"""" Center search result (only makes sense if zz is included in HighlightSearch too
"noremap n nzz
"noremap N Nzz
"""" Change definition of <word>
"au FileType python set iskeyword-=_

"""""""" Editing """"""""
"autocmd FileType python let b:foo=1
"if !exists("b:foo")
    nnoremap <leader>r ciw
"endif
"""" Like o but stay in normal
nnoremap ; o_<Esc>"_x
"""" Align relative to previous line(l because most commonly this is like a left shift)
nnoremap <leader>l ^v$h"ldO_<esc>"_x"lpjddk^
"""" Align by character
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
"""" Breakpoints
func! s:SetBreakpoint()
    cal append('.', repeat(' ', strlen(matchstr(getline('.'), '^\s*'))) . 'import ipdb; ipdb.set_trace()')
endf
func! s:RemoveBreakpoint()
    exe 'silent! g/^\s*import\sipdb\;\?\n*\s*ipdb.set_trace()/d'
endf
func! s:ToggleBreakpoint()
    if getline('.')=~#'^\s*import\sipdb' | cal s:RemoveBreakpoint() | el | cal s:SetBreakpoint() | en
endf
autocmd FileType python nnoremap <leader>b :call <SID>ToggleBreakpoint()<CR>
"""" Open function environment in csharp
autocmd FileType cs inoremap ;j <CR>{<CR>}<Esc>O

"""""""" Saving """"""""
nnoremap <leader>s :up<CR>
"""" Save files as sudo when vim was started without sudo.
cmap w!! w !sudo tee > /dev/null %
noremap Q :silent! call <SID>closecurrentbuffer()<CR>
nnoremap <leader><Esc> :silent call <SID>writeandclosecurrentbuffer()<CR>
nnoremap <leader>q :silent call <SID>writeandclosecurrentbuffer()<CR>
fun! s:writeandclosecurrentbuffer()
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt > 1
        update
        bwipeout
    else
        x
    endif 
endfun
fun! s:closecurrentbuffer()
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt > 1
        bdelete
    else
        q
    endif 
endfun

"""""""" Windows, buffers, and tabs """"""""
"""" Windows
nnoremap <C-W>n :vsplit<CR><C-W>w
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-h> <C-w>h
tnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
"""" Buffers
function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()
nnoremap \ :ProjectFiles<CR>
nnoremap <TAB> :bn<CR>
function! MyBufferList()
    if &buftype ==# 'quickfix' || &buftype ==# 'nofile'
        silent! execute "normal! \<CR>"
    else
        Buffers
    endif
endfunction
nnoremap <silent> <CR> :call MyBufferList()<CR>

"""""""" FX commands """"""""
"""" Undotree
nnoremap <F4> :GundoToggle<CR>
if has('python3')
	let g:gundo_prefer_python3 = 1
endif
"""" Run Python with F5
autocmd FileType python nnoremap <F5> :w <bar> exec '!python ./%' <CR>
autocmd FileType python inoremap <F5> <Esc>:w <bar> exec '!python ./%' <CR>
"""" Run latex with F5
autocmd FileType tex nmap <F5> :w<CR><Plug>(vimtex-view)
autocmd FileType tex imap <F5> <ESC>:w<CR><Plug>(vimtex-view)
autocmd FileType tex nmap <F1> :w<CR>:VimtexCompile<CR>
"autocmd FileType tex nnoremap <F5> :w <CR> :term latexmk -pvc <CR>
"autocmd FileType tex inoremap <F5> <Esc> :w <CR> :term latexmk -pvc <CR>
"autocmd FileType tex nnoremap <F1> :w <CR> :!nohup evince %:r.pdf & <CR>
"""" Toggle quickfix window
nnoremap <F6> :call <SID>ToggleQf()<cr>
function! s:ToggleQf()
    for buffer in tabpagebuflist()
        if bufname(buffer) == ''
            " then it should be the quickfix window
            cclose
            return
        endif
    endfor
    copen
endfunction
"""" Tagbar 
nnoremap <F8> :TagbarToggle<CR>
"""" Execute line in terminal
nnoremap <F9> Y<C-W>w<C-W>"0<C-W>w
xnoremap <F9> y<C-W>w<C-W>"0<C-W>w
"xnoremap <F9> y<C-W>w%paste<Enter><C-W>w
"""" REPL
autocmd FileType python nnoremap <F10> :REPLToggle<CR>
autocmd FileType python tnoremap <F10> <C-W>w :REPLToggle<CR>

"""""""" Format and indentation """"""""
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=0 expandtab autoindent fileformat=unix
autocmd FileType python set equalprg=autopep8\ -
autocmd FileType python set foldmethod=indent
autocmd FileType python set foldlevel=99

"""""""" Spelling """"""""
"""" Open spelling suggestions popup with CTRL-S in normal and insert mode (kind
"""" of replaces z= in normal mode (or 1z=)
nnoremap <C-S> a<C-X>s
inoremap <C-S> <C-X>s
"""" Check spelling in tex and txt files
autocmd BufRead,BufNewFile *.txt  setlocal spell
autocmd BufRead,BufNewFile *.tex  setlocal spell

"""""""" .vimrc """"""""
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>ve :source $MYVIMRC<cr>

"""""""""""""""""""""""""""""""""""" LOOKS """""""""""""""""""""""""""""""""""

"""""""" cursorline """"""""
"""" Highlight cursorline. Unfortunately slows down a lot with vim <8.1
"""" Unfortunately, bg color overrides bg highlighting eg in quickfixlist
set cursorline
"hi CursorLine cterm=bold,underline ctermbg=black 
hi Cursorline cterm=None
hi CursorLineNR ctermbg=red ctermfg=white cterm=bold

"""""""" statusline """"""""
hi StatusLine ctermbg=black ctermfg=gray 
set laststatus=2
set statusline=
set statusline+=%n       " buffer number
set statusline+=\ %<%F\  " full path
set statusline+=%r       " readonly flag
set statusline+=[%{&ff}] " file format
set statusline+=%m       " modified flag
set statusline+=%=%5l    " current line
set statusline+=/%L      " total lines
set statusline+=,\ %v      " virtual column number
set scrolloff=5
function! HighlightSearch(timer)
    if (g:firstCall)
        let g:originalStatusLineHLGroup = execute("hi StatusLine")
        let g:firstCall = 0
    endif
    if (exists("g:searching") && g:searching)
        let searchString = escape(getcmdline(), ' \')
        if searchString == "" 
            let searchString = "."
        endif
        let newBG = search(searchString) != 0 ? "green" : "red"
        if searchString == "."
            set whichwrap+=h
            normal h
            set whichwrap-=h
        endif
        execute("hi StatusLine ctermfg=" . newBG)
        let g:highlightTimer = timer_start(50, 'HighlightSearch')
    else
        let originalBG = matchstr(g:originalStatusLineHLGroup, 'ctermfg=\zs[^ ]\+')
        execute("hi StatusLine ctermfg=" . originalBG)
        "normal zz
        if exists("g:highlightTimer")
            call timer_stop(g:highlightTimer)
        endif
    endif
endfunction
augroup betterSeachHighlighting
    autocmd!
    autocmd CmdlineEnter * if (index(['?', '/'], getcmdtype()) >= 0) | let g:searching = 1 | let g:firstCall = 1 | call timer_start(1, 'HighlightSearch') | endif
    autocmd CmdlineLeave * let g:searching = 0
augroup END
