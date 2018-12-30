"TODO reasonable FX for preview quickix and location list
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
    "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'} " --bin instead if only needed in vim
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
    Plug 'terryma/vim-smooth-scroll'
    "Plug 'michaeljsmith/vim-indent-object'
    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-user'
    Plug 'soerenwolfers/diffchanges'
    "Plug 'simnalamburt/vim-mundo'
    "Try out Plug 'SirVer/ultinsips'
call plug#end()
let g:repl_program = {"python": "ipython --no-autoindent"}
filetype plugin indent on

"""""""" Plugin configuration """"""""
"""" vimtex 
let g:vimtex_view_method = 'zathura'
let g:vimtex_echo_verbose_input = 0 "No jumping at cse
"" To fix flickering issues, try vim8
"" Automatically start compiling when tex file is opened
augroup vimtex_config
  autocmd User VimtexEventInitPost !latexmk -C
  autocmd User VimtexEventInitPost VimtexCompile
augroup END
"""" fzf.vim
"" The standard fzf vim plugin is different from fzf.vim
"" and must be made accessible by hand
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
set rtp+=~/.fzf
"""" gundo
let g:gundo_preview_bottom = 1
"""" vimsurround 
let b:surround_indent = 1
"""" vim-commentary
function! UnmapCommentary()
    nunmap gc
    nunmap gcc
    nunmap gcu
endfunction
augroup unmapcommentary
    autocmd!
    autocmd VimEnter * call UnmapCommentary()
augroup END
"""" easymotion 
let g:EasyMotion_do_mapping=0
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
"""" vim-cool
let g:CoolTotalMatches=1 " show #match/#total at n N

"""""""" Basic options """"""""
let mapleader = " "
set showcmd               " Partial commands
set lazyredraw            " Quick macro application
set noerrorbells          " No annoying sounds
let &t_SI = "\e[6 q"      " Insert mode cursor
let &t_EI = "\e[2 q"      " Normal mode cursor
set timeoutlen=300        " map combination delay
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
set autoread
set showmode

"""""""" Advanced options """"""""
set completeopt-=preview " Python completion without preview window
set spelllang=en_us      " Spell checking
set hlsearch
set incsearch
"""" Ignore case in search unless search term contains capital letters
"""" Use \c to force case-insensitive, \C to force case-sensitive
set ignorecase
set smartcase
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "", 0700)
endif
set undodir=$HOME/.vim/undodir " Undo beyond sessions, create undodir manually!
set undofile
set undolevels=10000
set tabstop=4     " Display tabs as 4 spaces
set expandtab     " Replace inserted tabs by spaces
set shiftwidth=4  " Default indent 4 spaces
set nostartofline " Don't move cursor when switching buffers
set shortmess+=ast  " Very unverbose vim
set wildmenu      " Autocompletion menu in command mode
set history=1000 " Command history
set updatecount=20 " After how many characters is swp file written
set termguicolors
function! SetFocusedBuffer()
    setlocal cursorline wrap
    if &buftype!=#"nofile"
        setlocal relativenumber
    endif
endfunction
augroup BgHighlight
    autocmd!
    autocmd VimEnter,BufWinEnter,BufEnter,FocusGained,WinEnter * call SetFocusedBuffer()
    autocmd WinLeave,BufLeave,FocusLost * setlocal norelativenumber nocursorline
augroup END

"""""""" Fix vim stupidity """"""""
"""" Indent commands
xnoremap > >gv
xnoremap < <gv
func! Indent(ind)
  if &sol
    set nostartofline
  endif
  let vcol = virtcol('.')
  if a:ind
    norm! >>
    exe "norm!". (vcol + shiftwidth()) . '|'
  else
    norm! <<
    exe "norm!". (vcol - shiftwidth()) . '|'
  endif
endfunc
nnoremap <silent> > :call Indent(1)<cr>
nnoremap <silent> < :call Indent(0)<cr>
"""" Prevent quickfix and gundo window from preventing close of vim
augroup NoPreventClose
    autocmd!
    au BufEnter * call QuickFixQuit()
    au BufEnter * call GundoQuit()
augroup END
function! QuickFixQuit()
    if &buftype=="quickfix" && winnr('$') < 2
        call <SID>closecurrentbuffer()
    endif
endfunction
function! GundoQuit()
    if &buftype=="nofile" && (@% ==# "__Gundo__" || @% ==# "__Gundo_Preview__") && winnr('$') < 3 && (@# ==# "__Gundo__" || @# ==# "__Gundo_Preview__")
        call <SID>closecurrentbuffer()
        call <SID>closecurrentbuffer()
    endif
endfunction
"""" Make autoread work in terminal vim
if ! exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(20000,'CheckUpdate')
endfunction
"""" Add undo option for drastic insert line change
inoremap <C-U> <C-G>u<C-U> 

"""""""" Mode switches """"""""
"""" Enter visual line mode by vv
xnoremap <expr> v mode() ==# "v" ? "V" : "v"

"""""""" Insert mode """"""""
"""" Equivalent of x in normal, (X is <C-k> already)
imap <C-l> <del> 
"""" Go back one word in insert mode (also use <C-D> and <C-I> ((d)edent and (i)ndent))
imap <C-b> <C-o>b
imap <C-f> <C-o>w
"""" Scroll through suggestions (opened with <CTRL-X><...>)
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

"""""""" Command mode """"""""
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

"""""""" Range selection """"""""
"""" To next upper letter
onoremap u /\u<CR>
xnoremap u /\u<CR>
"""" Inside word
onoremap . iw
xnoremap . iw
"""" Inside and around indent block
omap ai :execute "normal v\<Plug>(textobj-indent-a)ok"<CR>
xmap <silent>ai <Plug>(textobj-indent-a)ok
omap <silent>ii <Plug>(textobj-indent-a)
xmap <silent>ii <Plug>(textobj-indent-a)
"""" Inside line
onoremap <silent> <CR> :<C-U>normal! ^v$h<CR>
"""" First function in line
onoremap <silent> F :<C-U>normal! 0f(hviw<CR>
"""" Inside first parentheses on line
onoremap <silent> A :<C-U>normal! 0f(lvi(<CR>

""""""""" Motions """"""""
map <leader>j <C-D>
map <leader>k <C-U>
"""" Smooth scroll
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 15, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 15, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 15, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 15, 4)<CR>
"""" By lines
noremap - G
"""" By characters
map ; <Plug>(easymotion-s)
"""" Move along displayed lines, not physical lines
noremap <expr> j v:count ? "j" : "gj"
noremap gj j
noremap <expr> k v:count ? "k" : "gk"
noremap gk k
"""" Beginning and end of line and screen
noremap H ^
noremap L $
noremap K H
"""" By math (allow pressing 4 instead of shift+4)
omap i4 <plug>(vimtex-i$)
omap a4 <plug>(vimtex-a$)
"""" Next and previous occurence
nnoremap t *
nnoremap T #
"""" Between hunks
map ]h <Plug>GitGutterNextHunk
map [h <Plug>GitGutterPrevHunk
"""" Between jumps
noremap ]j <C-I>
noremap [j <C-O>
"""" Between changes
noremap ]c g;
noremap [c g,
"""" To definition (I believe this is overwritten by Jedi-vim)
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>/ :Lines<CR>
"""" Center search result (only makes sense if zz is included in HighlightSearch too
"noremap n nzz
"noremap N Nzz
"""" Change definition of <word>
"au FileType python set iskeyword-=_

"""""""" Editing """"""""
"remember that :Ag opens all matching lines in repo, <Alt-A> <Alt-D> and <TAB>
"can be used to select, and :c(f)do s/a/b/c can be used to do substitutions
"on each quickfix entry of on each file that appears in quickfixlist
" Alternatively, :args selects files per glob, and :argdo does command on them
"
" Remember that <leader>r does refactoring by jedi-vim
"""" Align relative to previous line(l because most commonly this is like a left shift)
nnoremap <leader>l ^v$h"ldO_<esc>"_x"lpj"_ddk^
"""" Split
nnoremap <CR>j i<CR><esc>
"""" Comment out with `, uncomment with ``. In visual mode, do both with single `
xmap `  <Plug>Commentary
nmap ` <Plug>CommentaryLine
nmap `` <Plug>Commentary<Plug>Commentary
omap ` <Plug>Commentary
"""" Always go to exact mark position
noremap ' `
"""" Avoid jumping after aborted leader commands
map <leader> <nop>
"""" Align by character
nmap <leader>a <Plug>(EasyAlign)
xmap <leader>a <Plug>(EasyAlign)
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
"""" Paste in new line
nmap <leader>p :pu<CR><leader>l
"""" Redo
nnoremap U <C-R>
"""" Surround command (ys and S are provided from vim-surround)
nmap s ys
vmap s S
"""" Surround text with latex command
"" Recall you can already use l as surround type for latex environments
let g:surround_{char2nr('c')} = "\\\1command\1{\r}"
"""" Sensible (S)ubsistute (with target motion)
nnoremap <expr> S ":set opfunc=SensibleSubstitute\<CR>".'"'.v:register."g@"
function! SensibleSubstitute(type)
   let chosen_register = v:register
   normal! `[v`]
   exec 'normal! "_c'."\<C-r>".chosen_register
endfunction
function! s:ProperPaste(type)
    let aaa=v:register
    if a:type ==# 'v'
        normal! `<v`>
    elseif a:type == 'V'
        normal! `[v`]
    endif
    exec 'normal! "_c'."\<C-r>".aaa
endfunction
vnoremap <silent> p :<c-u>call <sid>ProperPaste(visualmode())<cr>
"""" Easyclip, basically
" nnoremap m d
" nnoremap M D
" nnoremap mm dd
" nnoremap d "_d
" nnoremap D "_D
" nnoremap dd "_dd
"""" Latex
function! s:startenvironment()
    execute "normal o\<esc>Vsl"
    normal o
endfunction
nmap zl :call <SID>startenvironment()<cr>

"""""""" Saving """"""""
nnoremap <leader>s :up<CR>
"""" Save files as sudo when vim was started without sudo.
cmap w!! w !sudo tee > /dev/null %
noremap <silent> Q :silent! call <SID>closecurrentbuffer()<CR>
noremap ZQ :call <SID>forceclosecurrentbuffer()<CR>
nnoremap <leader>q :silent call <SID>writeandclosecurrentbuffer()<CR>
fun! s:writeandclosecurrentbuffer()
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt > 1
        update
        bdelete
        "bwipeout
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
fun! s:forceclosecurrentbuffer()
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt > 1
        bdelete!
    else
        q!
    endif 
endfun

"""""""" Windows, buffers, and tabs """"""""
"" Recall that you can :mksession sessionname 
"" and vim -S sessionname 
"""" Windows
nnoremap <C-W>n :vsplit<CR><C-W>w
nnoremap <TAB> <C-W>w
nnoremap <S-TAB> <C-W>W
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
function! MyBufferList()
    if &buftype ==# 'quickfix' || &buftype ==# 'nofile'
        silent! execute "normal! \<CR>"
    else
        Buffers
    endif
endfunction
nnoremap <silent> <CR> :call MyBufferList()<CR>

"""""""" FX commands """"""""
"""" Diff changes since last save
nnoremap <F2> :DiffChangesPatchToggle<CR>
"""" Undotree
nnoremap <F4> :GundoToggle<CR>
if has('python3')
	let g:gundo_prefer_python3 = 1
endif
"""" Run Python with F5
let $PYTHONUNBUFFERED=1
autocmd FileType python nnoremap <S-F5> :w<CR>:AsyncRun -raw python3.5 %<CR>
autocmd FileType python nnoremap <F5> :w<bar>exec '!python3.5 ./%'<CR>
autocmd FileType python inoremap <S-F5> <Esc>:w<CR>:AsyncRun -raw python3.5 %<CR>
autocmd FileType python inoremap <F5> <Esc>:w<bar>exec '!python3.5 ./%'<CR>
"""" Run latex with F5
autocmd FileType tex nmap <F5> :w<CR><Plug>(vimtex-view)
autocmd FileType tex imap <F5> <ESC>:w<CR><Plug>(vimtex-view)
"""" Show errors (Quickfix list)
"autocmd FileType tex nmap <F6> :w<CR><Plug>(vimtex-errors)
"autocmd FileType tex nnoremap <F5> :w <CR> :term latexmk -pvc <CR>
"autocmd FileType tex inoremap <F5> <Esc> :w <CR> :term latexmk -pvc <CR>
"autocmd FileType tex nnoremap <F1> :w <CR> :!nohup evince %:r.pdf & <CR>
"""" Toggle quickfix window with F6
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
"""" Terminal 
nmap <F12> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>

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
"set cursorline
set nocursorline
hi Cursorline cterm=None term=None guibg=NONE cterm=underline,bold
hi CursorLineNR ctermbg=red ctermfg=white cterm=bold guibg=red guifg=white term=bold
"set cursorcolumn
"hi Cursorcolumn cterm=None term=None guibg=NONE

"""""""" statusline """"""""
hi StatusLine ctermbg=black ctermfg=white 
hi StatusLineNC ctermbg=black ctermfg=darkgray 
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
