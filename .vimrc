"TODO reasonable FX for preview quickix and location list
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
    ""Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'} " --bin instead if only needed in vim
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-surround' 
    Plug 'easymotion/vim-easymotion' "Only use single character bidirectional search; check kweasy as alternative
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
    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-user'
    Plug 'soerenwolfers/diffchanges'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'justinmk/vim-gtfo'
    Plug 'vim-scripts/replacewithregister'
    Plug 'AndrewRadev/splitjoin.vim'
    Plug 'romainl/vim-qf'
    Plug 'tpope/vim-abolish'
    Plug 'jeetsukumaran/vim-indentwise'
    Plug 'wellle/visual-split.vim'
    Plug 'bronson/vim-visual-star-search'
    Plug 'w0rp/ale'
    Plug 'takac/vim-hardtime'
    " Plug 'simnalamburt/vim-mundo'
    ""Plug 'blueyed/vim-diminactive'
    ""Try out Plug 'SirVer/ultinsips'
    ""Try out Plug 'welle/targets.vim'
call plug#end()
let g:repl_program = {"python": "ipython --no-autoindent"}
filetype plugin indent on
let mapleader = " "
"""""""""""""""""""""""""""""""" Plugin configuration """"""""""""""""""""""""""""""""  
""                                                                             vim-hardtime 
let g:hardtime_showmsg=1
let g:hardtime_default_on=1
""                                                                             vim-qf
""                                                                       (stop interference with vimtex)
let g:qf_auto_open_quickfix = 0 
""                                                                        Visual split
xmap <C-W>f  <Plug>(Visual-Split-VSResize)
xmap <C-W>s <Plug>(Visual-Split-VSSplit)
""                                                                          Splitjoin
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nmap <leader>j 0:SplitjoinJoin<CR>
nmap <leader>k 0:SplitjoinSplit<CR>
""                                                                          ale

""                                                                          vimtex 
""                                                                    (stop interference with qf)
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_echo_verbose_input = 0 "No jumping at cse
"" To fix flickering issues, try vim8
"" Automatically start compiling when tex file is opened
augroup vimtex_config
  "autocmd User VimtexEventInitPost !latexmk -C
  "autocmd User VimtexEventInitPost VimtexCompile
augroup END
"                                                                          fzf.vim
"" The standard fzf vim plugin is different from fzf.vim
"" and must be made accessible by hand
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
set rtp+=~/.fzf
""                                                                          gundo
let g:gundo_preview_bottom = 1
""                                                                         vimsurround 
let b:surround_indent = 1
""                                                                      vim-commentary
function! UnmapCommentary()
    nunmap gc
    nunmap gcc
    nunmap gcu
endfunction
augroup unmapcommentary
    autocmd!
    autocmd VimEnter * call UnmapCommentary()
augroup END
""                                                                      easymotion 
let g:EasyMotion_do_mapping=0
hi link EasyMotionTarget Search
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second Search
hi link EasyMotionShade Comment
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch Search
""                                                                      YouCompleteMe 
let g:ycm_autoclose_preview_window_after_completion=1
""                                                                      Jedi-vim 
let g:jedi#completions_enabled = 0 " No automatic popup of autocompletion (still available through <C-Space>)
""                                                                      vim-easytags 
autocmd FileType python let b:easytags_auto_highlight = 0
""                                                                      vim-cool
let g:CoolTotalMatches=1 " show #match/#total at n N

"""""""""""""""""""""""""""""""" Basic options """""""""""""""""""""""""""""""" 
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

"""""""""""""""""""""""""""""""" Advanced options """"""""""""""""""""""""""""""""  
set completeopt-=preview " Python completion without preview window
set spelllang=en_us      " Spell checking
set hlsearch
set incsearch
""                                                                    Ignore case in search 
""                                                                  unless search contains capitals 
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

"""""""""""""""""""""""""""""""" Fix vim stupidity """""""""""""""""""""""""""""""" 
""                                                                      Indent commands
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
" augroup NoPreventClose
"      autocmd!
    "au BufEnter * call QuickFixQuit()
    "au VimEnter,BufWinEnter,BufEnter,FocusGained,WinEnter * call GundoQuit()
" augroup END
" function! QuickFixQuit()
"     if &buftype=="quickfix" && winnr('$') < 2
"         call <SID>closecurrentbuffer()
"     endif
" endfunction
function! GundoQuit()
    if &buftype=="nofile" && (@% ==# "__Gundo__" || @% ==# "__Gundo_Preview__") && winnr('$') < 3 "&& (@# ==# "__Gundo__" || @# ==# "__Gundo_Preview__")
        call <SID>closecurrentbuffer()
    endif
endfunction
""                                                                    Make autoread work in terminal vim
if ! exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(20000,'CheckUpdate')
endfunction
""                                                                    undo for drastic insert change
inoremap <C-U> <C-G>u<C-U> 
""                                                                      Choose or yank all
onoremap ae :<C-U>normal! ggVG<CR>
xnoremap ae :<C-U>normal! ggVG<CR>
""                                                                                 Copy selection 
vmap <C-C> "+y
""                                                                           Make latex faster
let g:tex_flavor = "latex"
let g:tex_fast = "cmMprs"
let g:tex_conceal = ""
" let g:tex_fold_enabled = 0
let g:tex_comment_nospell = 1

"""""""""""""""""""""""""""""""" Mode switches """""""""""""""""""""""""""""""" 
""                                                                      Toggle visual line
xnoremap <expr> v mode() ==# "v" ? "V" : "v"

"""""""""""""""""""""""""""""""""" Insert mode """"""""""""""""""""""""""""""""
""                                                                      Equivalent of x in normal
""                                      Recall <C-D> (d)edent (opposite of (i)ndent=<C-i>=TAB=indent)
imap <C-l> <C-o>l<bs>
""                                                                      Go back one word 
imap <C-b> <C-o>b
imap <C-f> <C-o>w
""                                                                      Scroll through suggestions 
""                                                                      (opened with <CTRL-X><...>)
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

"""""""""""""""""""""""""""""""" Command mode """""""""""""""""""""""""""""""" 
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
"""""""""""""""""""""""""""""""" Range selection """""""""""""""""""""""""""""""" 
""                                                                      To next upper letter
onoremap u /\u<CR>
xnoremap u /\u<CR>
""                                                                      Inside word
onoremap . iw
xnoremap . iw
""                                                                      Inside and around indent block
omap ai :execute "normal v\<Plug>(textobj-indent-a)ok"<CR>
xmap <silent>ai <Plug>(textobj-indent-a)ok
omap <silent>ii <Plug>(textobj-indent-a)
xmap <silent>ii <Plug>(textobj-indent-a)
""                                                                      Inside line
onoremap <silent> <CR> :<C-U>normal! ^v$h<CR>
""                                                                      First function in line
onoremap <silent> F :<C-U>normal! 0f(hviw<CR>
""                                                                      Inside first parentheses on line
onoremap <silent> A :<C-U>normal! 0f(lvi(<CR>

"""""""""""""""""""""""""""""""" Motions """""""""""""""""""""""""""""""" 
"" It makes no sense to try to keep the cursor where it is (with <C-Y>)
"" Because of vim's cursor model, this fails after one page anyway.
function! s:myDown()
    let h=winheight('.')
    let l=h/5
    " let oldscrolloff=&scrolloff
    " if line(".")-line("w0")>l
        " let &scrolloff=l
    " endif
    execute "normal! " . l . "j" 
    " let &scrolloff=oldscrolloff
endfunction
function! s:myUp()
    let h=winheight('.')
    let l=h/5
    " let oldscrolloff=&scrolloff
    " if line("w$")-line(".")>l
        " let &scrolloff=l
    " endif
    execute "normal! " . l . "k"
    " let &scrolloff=oldscrolloff
endfunction
nnoremap <silent> <C-U> :call <SID>myUp()<CR>
nnoremap <silent> <C-D> :call <SID>myDown()<CR>
function! s:mySmoothDown()
    let h=winheight('.')
    call smooth_scroll#down(h,1200/h,4)
endfunction
function! s:mySmoothUp()
    let h=winheight('.')
    call smooth_scroll#up(h, 1200/h, 4)
endfunction
noremap <silent> <c-b> :call <SID>mySmoothUp()<CR>
noremap <silent> <c-f> :call <SID>mySmoothDown()<CR>
""                                                                      By lines
noremap - G
""                                                                      By characters
map ; <Plug>(easymotion-s)
""                                                                      Along displayed lines
nnoremap <expr> j v:count ? "j" : "gj"
nnoremap gj j
nnoremap <expr> k v:count ? "k" : "gk"
nnoremap gk k
""                                                                      Beginning and end of line and screen
noremap H g^
noremap L g$
noremap K H
""                                                                      By math (allow pressing 4 instead of shift+4)
omap i4 <plug>(vimtex-i$)
omap a4 <plug>(vimtex-a$)
""                                                                      Next and previous occurence
nnoremap t *
nnoremap T #
""                                                                      Between hunks
map ]h <Plug>GitGutterNextHunk
map [h <Plug>GitGutterPrevHunk
""                                                                      Between jumps
noremap ]j <C-I>
noremap [j <C-O>
""                                                                      Between changes
noremap ]c g;
noremap [c g,
""                                                                      To definition 
""                                           (I believe this is overwritten by Jedi-vim)
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>/ :Lines<CR>
""                                                                      Center search result 
""                                                        (only makes sense if zz is included in HighlightSearch too)
"noremap n nzz
"noremap N Nzz
""                                                                     Change definition of <word>
"au FileType python set iskeyword-=_

"""""""""""""""""""""""""""""""" Editing """""""""""""""""""""""""""""""" 
"remember that :Ag opens all matching lines in repo, <Alt-A> <Alt-D> and <TAB>
"can be used to select, and :c(f)do s/a/b/c can be used to do substitutions
"on each quickfix entry of on each file that appears in quickfixlist
" Alternatively, :args selects files per glob, and :argdo does command on them
"
" Remember that <leader>r does refactoring by jedi-vim
""                                                                     Align relative to previous line
""                                                                     (l because commonly results in left shift)
"" THATS WHAT "=" is for. However, this code is more strict, i.e., sometimes 
"" "=" leaves the line as they are if there are multiple legal indents.
"" This code however knows only one correct indenting style: the one 
"" that the insert mode provides upon `o`
"nnoremap <leader>l ^v$h"ldO_<esc>"_x"lpj"_ddk^
nmap <leader>l V<leader>l
xnoremap <expr><leader>l (mode() ==# "v" ? "V" : "" ) . "\"pc\<esc>" . ":<C-U>call <SID>properpastevisual()\<CR>"
function! s:properpastevisual()
    normal k
    let temp = @p
    let originalpaste=&paste
    let originaltextwidth=&textwidth
    set nopaste
    for l:line in split(temp,"\n")
        normal o
        if getline(line(".")) =~ "^$"
            normal "_dd
            normal Ox
            normal "_x
        else
            normal ^"_d$
        endif
        execute "normal A" . trim(l:line)
    endfor
    let paste = originalpaste
    let textwidth = originaltextwidth
    normal j"_ddk^
endfunction
""                                                                        Commenting
xmap `  <Plug>Commentary
nmap ` <Plug>CommentaryLine
nmap `` <Plug>Commentary<Plug>Commentary
omap ` <Plug>Commentary
""                                                                    Always go to exact mark position
noremap ' `
""                                                                      Avoid jumping after aborted leader commands
map <leader> <nop>
""                                                                      Align by character
nmap <leader>a <Plug>(EasyAlign)
xmap <leader>a <Plug>(EasyAlign)
""                                                                      Breakpoints
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
""                                                                      Open function environment in csharp
autocmd FileType cs inoremap ;j <CR>{<CR>}<Esc>O
""                                                                      Paste in new line with vims auto indentation 
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
function! s:properpaste()
    " let chosen_register = v:register
    " let m = strpart(getregtype(),0,1)
    " if m ==# 'v'
    "     normal o
    " endif
    " exec 'normal! "' . chosen_register . 'p'
    " execute "normal! `[" . m . "`]="
    execute "let temp = @" . v:register
    let originalpaste=&paste
    let originaltextwidth=&textwidth
    set nopaste
    for l:line in split(temp,"\n")
        normal o
        if getline(line(".")) =~ "^$"
            normal "_dd
            normal Ox
            normal "_x
        else
            normal ^"_d$
        endif
        execute "normal A" . trim(l:line)
    endfor
    let paste = originalpaste
    let textwidth = originaltextwidth
endfunction
nmap <leader>p :call <SID>properpaste()<CR>
""                                                                      Redo
nnoremap U <C-R>
""                                                                      Surround command 
""                                                                (normalmode-ys and visualmode-S by vim-surround)
nmap S ys
""                                                                      Surround text with latex command
"" Recall you can already use l as surround type for latex environments
let g:surround_{char2nr('c')} = "\\\1command\1{\r}"
""                                                                 Sensible (S)ubstitute 
""                                                                     .e. no overwrite
"" visual mode gr is provided by plugin ReplaceWithRegister
vmap R gr
nmap R gr
"" The below is almost equivalent but less stable as gr
" nnoremap <expr> R ":set opfunc=SensibleSubstitute\<CR>".'"'.v:register."g@"
" function! SensibleSubstitute(type)
"    let chosen_register = v:register
"    normal! `[v`]
"    exec 'normal! "_c'."\<C-r>".chosen_register
" endfunction
"""" Easyclip, basically
" nnoremap m d
" nnoremap M D
" nnoremap mm dd
" nnoremap d "_d
" nnoremap D "_D
" nnoremap dd "_dd
""                                                                      Latex environments
"" Requires S in visual mode to be (S)urround by vim-surround
function! s:startenvironment()
    execute "normal o\<esc>VSl"
    normal o
endfunction
nmap zl :call <SID>startenvironment()<cr>

"""""""""""""""""""""""""""""""" Saving """""""""""""""""""""""""""""""" 
nnoremap <leader>s :up<CR>
""                                                                    Save files as sudo 
command! SudoSave w !sudo tee >/dev/null %
noremap Q :call <SID>closecurrentbuffer()<CR>
noremap ZQ :call <SID>closecurrentbuffer(1)<CR>
nnoremap <leader>q :update<CR>:silent! call <SID>closecurrentbuffer()<CR>
fun! s:closecurrentbuffer(...)
    if a:0 > 0
        let l:force=a:1
    else
        let l:force=0
    endif
    if winnr('$') > 1
        if l:force
            q!
        else
            q
        endif
    else
        if &buftype=="nofile" && @% ==# "[Command Line]"
            if l:force
                q!
            else
                q
            endif
        elseif &buftype=="quickfix" 
            try
                if w:quickfix_title =~# 'Syntastic'
                    " Unfortunately the close command below is undone immediately if
                    " Syntastic mode is active. However, at least this puts you back to
                    " another buffer where closecurrentbuffer() can be run again.
                    lclose
                endif
            catch
                cclose
            endtry
        else
            "" Uncomment the below if vim-qf is uninstalled
            "cclose
            "lclose
            let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
            if bufcnt > 1
                if l:force
                    bdelete!
                else
                    bdelete
                endif
            else "bdelete would result in a new empty buffer instead of closing vim
                if l:force
                    q!
                else
                    q
                endif
            endif 
        endif
    endif
    call GundoQuit()
endfun

"""""""""""""""""""""""""""""""" Windows, buffers, and tabs """"""""""""""""""""""""""""""""
"" Recall that you can :mksession sessionname 
"" and vim -S sessionname 
""                                                                      Windows
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
""                                                                      Buffers
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

"""""""""""""""""""""""""""""""" FX commands """"""""""""""""""""""""""""""""
""                                                                      Start compilation with F1
autocmd FileType tex nmap <F1> :w<CR>:VimtexCompile<CR>
""                                                                      Diff changes since last save with F2
nnoremap <F2> :DiffChangesPatchToggle<CR>
""                                                                      Diff changes since file was opened with S-F2
augroup DiffSinceLoadGroup
    autocmd!
    autocmd BufReadPost * let b:undo_seq_load=changenr()
augroup END
function! DiffSinceLoad()
    let tmpa = tempname()
    let tmpb = tempname()
    let curchange=changenr()
    exe "undo " . b:undo_seq_load
    exec 'w '.tmpa
    exe "undo " . curchange
    exec 'w '.tmpb
    update
    exec 'tabnew '.tmpa
    diffthis
    vert split
    exec 'edit '.tmpb
    diffthis
endfunction
command! -nargs=0 DiffSinceLoad call DiffSinceLoad()
nnoremap <S-F2> :DiffSinceLoad<CR>
""                                                                      Syntax check with F3 (location list)
" nmap <F3> :SyntasticCheck<CR>
""                                                                      Undotree with F4
nnoremap <F4> :GundoToggle<CR>
if has('python3')
	let g:gundo_prefer_python3 = 1
endif
""                                                                      Run Python with F5
let $PYTHONUNBUFFERED=1
autocmd FileType python nnoremap <S-F5> :w<CR>:AsyncRun -raw python %<CR>
autocmd FileType python nnoremap <F5> :w<bar>exec '!python ./%'<CR>
autocmd FileType python inoremap <S-F5> <Esc>:w<CR>:AsyncRun -raw python %<CR>
autocmd FileType python inoremap <F5> <Esc>:w<bar>exec '!python ./%'<CR>
""                                                                      Run latex with F5
autocmd FileType tex nmap <F5> :w<CR><Plug>(vimtex-view)
autocmd FileType tex imap <F5> <ESC>:w<CR><Plug>(vimtex-view)
""                                                                      Show errors (Quickfix list)
"autocmd FileType tex nmap <F6> :w<CR><Plug>(vimtex-errors)
"autocmd FileType tex nnoremap <F5> :w <CR> :term latexmk -pvc <CR>
"autocmd FileType tex inoremap <F5> <Esc> :w <CR> :term latexmk -pvc <CR>
"autocmd FileType tex nnoremap <F1> :w <CR> :!nohup evince %:r.pdf & <CR>
""                                                                      Toggle quickfix window with F6
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
""                                                                      Tagbar 
nnoremap <F8> :TagbarToggle<CR>
""                                                                      Execute line in terminal
nnoremap <F9> Y<C-W>w<C-W>"0<C-W>w
xnoremap <F9> y<C-W>w<C-W>"0<C-W>w
"xnoremap <F9> y<C-W>w%paste<Enter><C-W>w
""                                                                      REPL
autocmd FileType python nnoremap <F10> :REPLToggle<CR>
autocmd FileType python tnoremap <F10> <C-W>w :REPLToggle<CR>
""                                                                      Terminal 
nmap <F12> :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>

"""""""""""""""""""""""""""""""" Format and indentation """"""""""""""""""""""""""""""""
augroup PythonSettings
    autocmd!
    au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=0 expandtab autoindent fileformat=unix
    ""Cant change equalprg to autopep8 because it messes up splitjoinsplit
    "autocmd FileType python set equalprg=autopep8\ -
    autocmd FileType python xmap = !autopep8 -<CR>
    autocmd FileType python set foldmethod=indent
    autocmd FileType python set foldclose=all
    autocmd FileType python set foldtext=v:folddashes
    autocmd FileType python set foldlevel=1
    autocmd FileType python set foldnestmax=2
augroup END

"""""""""""""""""""""""""""""""" Spelling """"""""""""""""""""""""""""""""
""                                                                      Spelling suggestions with CTRL-S
""                                                                      replaces z= in normal mode (or 1z=)
nnoremap <C-S> a<C-X>s
inoremap <C-S> <C-X>s
""                                                                      Check spelling in tex and txt files
autocmd BufRead,BufNewFile *.txt  setlocal spell
autocmd BufRead,BufNewFile *.tex  setlocal spell

"""""""""""""""""""""""""""""""""""" .vimrc """"""""""""""""""""""""""""""""
nnoremap <leader>ev :edit $MYVIMRC<cr>
function! s:SaveVimRC()
    let l:rc = $MYVIMRC
    let l:brc = bufnr(l:rc)
    let l:bc = bufnr("%")
    if l:brc>0
        execute "buffer " . l:brc
        update
        execute "buffer " . l:bc
    endif
endfunction
nnoremap <leader>ve :call <SID>SaveVimRC()<CR>:source $MYVIMRC<CR>

"""""""""""""""""""""""""""""""" LOOKS """"""""""""""""""""""""""""""""
""                                                                       Folds
nmap <leader>0 :set foldlevel=0<CR>
nmap <leader>1 :set foldlevel=1<CR>
nmap <leader>2 :set foldlevel=2<CR>
nmap <leader>3 :set foldlevel=3<CR>
nmap <leader>4 :set foldlevel=4<CR>
nmap <leader>5 :set foldlevel=5<CR>
nmap <leader>6 :set foldlevel=6<CR>
nmap <leader>7 :set foldlevel=7<CR>
nmap <leader>8 :set foldlevel=8<CR>
nmap <leader>9 :set foldlevel=9<CR>
"""""""""""""""""""""""""""""""" cursorline """"""""""""""""""""""""""""""""
""                                                                    Highlight cursorline
"""" Unfortunately, bg color overrides bg highlighting eg in quickfixlist
"set cursorline
set nocursorline
hi Cursorline cterm=None term=None guibg=NONE cterm=underline,bold
hi CursorLineNR ctermbg=red ctermfg=white cterm=bold guibg=red guifg=white term=bold
"set cursorcolumn
"hi Cursorcolumn cterm=None term=None guibg=NONE

"""""""""""""""""""""""""""""""" statusline """"""""""""""""""""""""""""""""
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
        let searchString = getcmdline()
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
        let g:searchString = searchString
    else
        let originalBG = matchstr(g:originalStatusLineHLGroup, 'ctermfg=\zs[^ ]\+')
        execute("hi StatusLine ctermfg=" . originalBG)
        if exists("g:highlightTimer")
            call timer_stop(g:highlightTimer)
            call HighlightCursorMatch()
            " call timer_start(2000,'UnmatchSearch')
        endif
    endif
endfunction
" function! UnmatchSearch(...)
"     match
" endfunction
function! HighlightCursorMatch() 
    try
        let l:patt = '\%#'
        if &ic | let l:patt = '\c' . l:patt | endif
        exec 'match IncSearch /' . l:patt . g:searchString . '/'
    endtry
endfunction
nnoremap n n:call HighlightCursorMatch()<CR>
nnoremap N N:call HighlightCursorMatch()<CR>
augroup betterSeachHighlighting
    autocmd!
    autocmd CmdlineEnter * if (index(['?', '/'], getcmdtype()) >= 0) | let g:searching = 1 | let g:firstCall = 1 | call timer_start(1, 'HighlightSearch') | endif
    autocmd CmdlineLeave * let g:searching = 0
augroup END
