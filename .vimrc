"Set up vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround' 
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'sillybun/vim-repl', {'do': './install.sh'}
Plug 'vim-scripts/indentpython.vim'
Plug 'airblade/vim-gitgutter'
Plug 'romainl/vim-cool'
Plug 'davidhalter/jedi-vim'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
call plug#end()
let g:repl_program = {"python": "ipython"}
"Set up Vundle
set nocompatible 
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" Autopep8 for auto format upon :Autopep8 (see shortcut below)
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'sjl/gundo.vim'
Plugin 'tell-k/vim-autopep8'
call vundle#end()
filetype plugin indent on
"Show partial commands
set showcmd 
"Show search
set hlsearch
set incsearch
"Use different cursor for insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
"Accelerate switch between cursor types (Reason: Escape character is in general not processed directly as it used to be used as an 'escape' character (like backslash nowadays).)
set timeoutlen=500 ttimeoutlen=0
"Automatically store to system clipboard
set clipboard=unnamedplus
"Use mouse to switch and close tabs
set mouse=a
"Make backspace work
set bs=2
"Python indentation etc.
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=0 expandtab autoindent fileformat=unix
" Python completion without preview window
set completeopt-=preview
"Spell checking
set spelllang=en_us
autocmd BufRead,BufNewFile *.txt  setlocal spell
autocmd BufRead,BufNewFile *.tex  setlocal spell
" Ignore case in search unless search term contains capital letters
" (Must first set ignorecase before smartcase)
set ignorecase
set smartcase
imap <C-l> <del>
" Go back one word in insert mode (CTRL-O executes single normal command)
imap <C-b> <C-o>b
"imap <C-f> <C-o>w
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
let mapleader = " "
" Enter visual line mode 
nnoremap vv V
xnoremap vv V
" Move along displayed lines, not physical lines
noremap gj j
noremap j gj
noremap gk k
noremap k gk
filetype on
" Run Python with F5
autocmd FileType python nnoremap <F5> :w <bar> exec '!python ./%' <CR>
autocmd FileType python inoremap <F5> <Esc>:w <bar> exec '!python ./%' <CR>
" Tab to switch windows
nnoremap <Tab> <C-W>w
nnoremap <C-W>n :vsplit<CR><C-W>w
" Go through jumplist. Cannot use the original C-I because that's equal to TAB (because of how Terminal's work) and TAB is already used to switch windows
nnoremap <C-P> <C-O>
nnoremap <C-N> <C-I>
"au FileType python set iskeyword-=_
" Open spelling suggestions popup with CTRL-S in normal and insert mode (kind
" of replaces z= in normal mode (or 1z=)
nnoremap <C-S> a<C-X>s
inoremap <C-S> <C-X>s
" Undotree
nnoremap <leader>u :GundoToggle<CR>
" Undotree installation fix to use Python 3
if has('python3')
	let g:gundo_prefer_python3 = 1
endif
"Shift all the way to left
xnoremap <leader>h :left<CR>
nnoremap <leader>h :left<CR> 
" Motion: Go to next capital letter
onoremap u /\u<CR>
" Scroll through suggestions (opened with <CTRL-X><...>
inoremap <C-J> <C-N>
inoremap <C-K> <C-P>
" fzf standard plugin (advanced fzf.vim is installed at the beginning of this script
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
nnoremap \ :Files<CR>
" To make :Buffers work with unsaved buffers, need the following line
set hidden
nnoremap <CR> :Buffers<CR>
nnoremap <leader>/ :Lines<CR>
nnoremap <leader><Esc> :call <SID>writeandclosecurrentbuffer()<CR>
nnoremap <Esc><leader> :call <SID>writeandclosecurrentbuffer()<CR>
nnoremap - G
xnoremap - G
onoremap - G
"When <CR> is remapped, can't use it to select items in command history,
"unless the following two lines are used:
:autocmd CmdwinEnter * nnoremap <CR> <CR>
:autocmd BufReadPost quickfix nnoremap <CR> <CR>
" Autopep8 callable through '=' on Python files
autocmd FileType python set equalprg=autopep8\ -
" Highlight cursorline. Unfortunately slows down a lot with vim <8.1)
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white ctermbg=black
" Undo beyond sessions
set undodir="$HOME/.vim/undodir"
set undofile
" Open function environment in csharp
autocmd FileType cs inoremap ;j <CR>{<CR>}<Esc>O
fun! s:writeandclosecurrentbuffer()
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt > 1
        update
        bwipeout
    else
        x
    endif 
endfun
"Display tabs as 4 spaces
set tabstop=4
"Replace inserted tabs by spaces
set expandtab
"Default indent 4 spaces
set shiftwidth=4
"Autoindent after surround with vim-surrouond
let b:surround_indent = 1
map <leader>f <Plug>(easymotion-f)
hi link EasyMotionTarget Search
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search
hi link EasyMotionShade Comment
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search
"Save shortcut
nnoremap <leader>s :up<CR>
"
autocmd FileType python set foldmethod=indent
autocmd FileType python set foldlevel=99
" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" GitGutter
"let g:gitgutter_highlight_lines = 1
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
"Jedi-vim only for <leader>d etc. , not for completion
let g:jedi#completions_enabled = 0
" vim-easytags
autocmd FileType python let b:easytags_auto_highlight = 0
" Automatic relative line numbering
set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
hi StatusLine ctermbg=black ctermfg=white 
function! HighlightSearch(timer)
    " When it is the first call to the function we save the current status of
    " the StatusLine HL group so that we can restore it when we are done searching
    if (g:firstCall)
        let g:originalStatusLineHLGroup = execute("hi StatusLine")
        let g:firstCall = 0
    endif
    if (exists("g:searching") && g:searching)
        " The variable g:searching is set to 1, we are in the search command line
        " make the highlighting and call the function again after a delay
        let searchString = escape(getcmdline(), ' \')
        let newBG = search(searchString) != 0 ? "green" : "red"
        if (&laststatus!=2)
            set laststatus=2
        endif
        execute("hi StatusLine ctermfg=" . newBG)
        let g:highlightTimer = timer_start(300, 'HighlightSearch')
    else
        " The variable g:searching is either not set or set to 0, we stopped searching
        " restore the hightlighting and stop calling the function
        let originalBG = matchstr(g:originalStatusLineHLGroup, 'ctermfg=\zs[^ ]\+')
        if (&laststatus!=1)
            set laststatus=1
        endif
        execute("hi StatusLine ctermfg=" . originalBG)
        if exists("g:highlightTimer")
            call timer_stop(g:highlightTimer)
        endif
    endif
endfunction

" Define an autocmd to call the HighLightSearch function when we enter the search command line
" And a second one to stop the function when we are done searching
augroup betterSeachHighlighting
    autocmd!
    autocmd CmdlineEnter * if (index(['?', '/'], getcmdtype()) >= 0) | let g:searching = 1 | let g:firstCall = 1 | call timer_start(1, 'HighlightSearch') | endif
    autocmd CmdlineLeave * let g:searching = 0
augroup END
