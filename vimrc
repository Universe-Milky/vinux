"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/t-vim
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"System check{{{
set filetype=text
if te#env#IsWindows()
    let $HOME=$VIM
    let $VIMFILES = $VIM.'\\vimfiles'
    set makeprg=mingw32-make
else
    set keywordprg=""
    set path=.,/usr/include/
    let $VIMFILES = $HOME.'/.vim'
endif


"}}}
"Basic setting{{{

"Encode {{{
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb1830,big5,euc-jp,euc-kr,gbk
if v:lang=~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif
source $VIMRUNTIME/delmenu.vim
lan mes en_US.UTF-8
"set langmenu=nl_NL.ISO_8859-1
:scriptencoding utf-8
"}}}

"{{{autocmd autogroup

augroup fold_group
    autocmd!
augroup END

augroup quickfix_group
    autocmd!
    au BufWinEnter quickfix  noremap <buffer> q :q<cr>
    " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
    autocmd BufReadPost quickfix nnoremap <buffer> s <C-w><Enter><C-w>K
augroup END

augroup misc_group
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> q :q<cr>
augroup END

"automatic recognition vt file as verilog 
augroup filetype_group
    autocmd!
    au BufRead,BufNewFile *.vt setlocal filetype=verilog
    "automatic recognition bld file as javascript 
    au BufRead,BufNewFile *.bld setlocal filetype=javascript
    "automatic recognition xdc file as javascript
    au BufRead,BufNewFile *.xdc setlocal filetype=javascript
    au BufRead,BufNewFile *.mk setlocal filetype=make
    au BufRead,BufNewFile *.make setlocal filetype=make
    au BufRead,BufNewFile *.veo setlocal filetype=verilog
    au BufRead,BufNewFile * let $CurBufferDir=expand('%:p:h')
    au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} :setlocal filetype=markdown 
    au BufRead,BufNewFile *.hex,*.out,*.o,*.a Vinarise
    au BufEnter * 
                \ if &diff |
                \ set statusline=%!MyStatusLine(2) |
                \ endif
augroup END

"}}}

"{{{fold setting
"folding type: manual, indent, expr, marker or syntax
set foldenable                  " enable folding
autocmd fold_group FileType sh setlocal foldmethod=indent
set foldlevel=100         " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldcolumn=1
function! MyFoldText()
    let line = getline(v:foldstart)
    if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
        let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
        let linenum = v:foldstart + 1
        while linenum < v:foldend
            let line = getline( linenum )
            let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
            if comment_content !=? ''
                break
            endif
            let linenum = linenum + 1
        endwhile
        let sub = initial . ' ' . comment_content
    else
        let sub = line
        let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
        if startbrace ==? '{'
            let line = getline(v:foldend)
            let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
            if endbrace ==? '}'
                let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
            endif
        endif
    endif
    let n = v:foldend - v:foldstart + 1
    let info = ' ' . n . ' lines'
    let sub = sub . '                                                                                                                  '
    let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
    let fold_w = getwinvar( 0, '&foldcolumn' )
    let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
    return sub . info
endfunction
set foldtext=MyFoldText()
nnoremap sj za
vnoremap sf zf
nnoremap sk zM
nnoremap si zi
"}}}

"list candidate word in statusline
set wildmenu
set wildmode=longest,full
set wic
"set list  "display unprintable characters by set list
set listchars=tab:\|\ ,trail:-  "Strings to use in 'list' mode and for the |:list| command
au misc_group BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif "jump to last position last open in vim

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5
" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

"{{{backup
set backup "generate a backupfile when open file
set backupext=.bak  "backup file'a suffix
set backupdir=$VIMFILES/vimbackup  "backup file's directory
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif
"}}}
"do not Ring the bell (beep or screen flash) for error messages
set noerrorbells
set mat=2  
set report=0  "Threshold for reporting number of lines changed
set lazyredraw  " Don't update the display while executing macros
set helplang=en,cn  "set helplang=en
set autoread   "autoread when a file is changed from the outside
set relativenumber number "show the line number for each line
set cmdheight=1  "number of lines used for the command-line
set showmatch "when inserting a bracket, briefly jump to its match
set printfont=Yahei_Mono:h10:cGB2312  "name of the font to be used for :hardcopy
set smartcase  "override 'ignorecase' when pattern has upper case characters
set confirm  "start a dialog when a command fails
set smartindent "do clever autoindenting
"set nowrap   "don't auto linefeed

"linux kernel coding stype
set tabstop=8  "number of spaces a <Tab> in the text stands for
set shiftwidth=8 "number of spaces used for each step of (auto)indent
set softtabstop=8  "if non-zero, number of spaces to insert for a <Tab>
set noexpandtab
set nosmarttab "a <Tab> in an indent inserts 'shiftwidth' spaces
set textwidth=80

set hlsearch "highlight all matches for the last used search pattern
set showmode "display the current mode in the status line
"set ruler  "show cursor position below each window
set selection=inclusive  ""old", "inclusive" or "exclusive"; how selecting text behaves
set is  "show match for partly typed search command
"set lbr "wrap long lines at a character in 'breakat'
set backspace=indent,eol,start  "specifies what <BS>, CTRL-W, etc. can do in Insert mode
set whichwrap=b,h,l,<,>,[,]  "list of menu_flags specifying which commands wrap to another line
set mouse=a "list of menu_flags for using the mouse,support all

"unnamed" to use the * register like unnamed register
"autoselect" to always put selected text on the clipboardset clipboard+=unnamed
set clipboard+=unnamed
"set autochdir  "change to directory of file in buffer

"statuslne
function! MyStatusLine(type)
    let l:mystatus_line='%<%t%m%r%h%w'
    let l:mystatus_line.="%{exists(':TagbarToggle')?\ tagbar#currenttag('[%s]','')\ :\ ''}"
    if a:type == 1
        let l:mystatus_line.="%=[%{(&fenc!=''?&fenc:&enc)}\|%{&ff}\|%Y][%l,%v][%p%%]%{exists('*fugitive#statusline')?\ fugitive#statusline()\ :\ ''}"
        let l:mystatus_line.="[%{strftime(\"%m/%d\-\%H:%M\")}]"
    endif
    if exists('g:asyncrun_status') && g:asyncrun_status !=# ''
       let l:mystatus_line.='['.g:asyncrun_status.']'
    endif
    return l:mystatus_line
endfunction
set statusline=%!MyStatusLine(1)
set guitablabel=%N\ %t  "do not show dir in tab
"0, 1 or 2; when to use a status line for the last window
set laststatus=2 "always show status
set stal=1  "always show the tabline
set sessionoptions-=folds
set sessionoptions-=options
set ffs=unix,dos,mac
au misc_group BufRead * if &ff=="dos" | setlocal ffs=dos,unix,mac | endif  
au misc_group VimResized * wincmd = 

if te#env#IsNvim()
    "terminal-emulator setting
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif


"}}}
"Key mapping{{{

" normal no remap function
" maptype:type of keymap,nnoremap, map ie.
" keycodes:such as <C-d>
" action: map action.
function! TracyoneKeyMap(maptype,keycodes,action)
    execute a:maptype.' '.a:keycodes.' '.a:action
endfunction

"map jj to esc..
"fuck the meta key...
if !te#env#IsNvim()
    if(!te#env#IsGui())
        let c='a'
        while c <=# 'z'
            exec 'set <m-'.c.">=\e".c
            exec "inoremap \e".c.' <m-'.c.'>'
            let c = nr2char(1+char2nr(c))
        endw
        let d='1'
        while d <=? '9'
            exec 'set <m-'.d.">=\e".d
            exec "inoremap \e".d.' <m-'.d.'>'
            let d = nr2char(1+char2nr(d))
        endw
    endif
endif

set timeout timeoutlen=1000 ttimeoutlen=100
""no", "yes" or "menu"; how to use the ALT key
set winaltkeys=no

"leader key
let g:mapleader="\<Space>"
let g:maplocalleader=','
inoremap jj <c-[>

vnoremap [p "0p

"visual mode hit tab forward indent ,hit shift-tab backward indent
vnoremap <TAB>  >gv  
vnoremap <s-TAB>  <gv 
"Ctrl-tab is not work in vim
nnoremap <silent><c-TAB> :AT<cr>
nnoremap <silent><right> :tabnext<cr>
nnoremap <silent><Left> :tabp<cr>

"{{{ alt or meta key mapping
" in mac osx please set your option key as meta key

if te#env#IsMacVim()
    let s:alt_char={1:'¡',2:'™',3:'£',4:'¢',5:'∞',6:'§',7:'¶',8:'•',9:'ª'
                \,'t':'†','q':'œ','a':'å','=':'≠','h':'˙','l':'¬','j':'∆','k':'˚'
                \,'o':'ø','-':'–','b':'∫','f':'ƒ','m':'µ','w':'∑'}
elseif te#env#IsUnix() && !te#env#IsNvim() && !te#env#IsGui()
    let s:alt_char={1:'±' ,2:'²',3:'³',4:'´',5:'µ',6:'¶',7:'·',8:'¸',9:'¹'
                \,'t':'ô','q':'ñ','a':'á','=':'½','h':'è','l':'ì','j':'ê','k':'ë'
                \,'o':'ï','-':'­','b':'â','f':'æ','m':'í','w':'÷'}
elseif te#env#IsGui() || te#env#IsNvim()
    let s:alt_char={1:'<m-1>',2:'<m-2>',3:'<m-3>',4:'<m-4>',5:'<m-5>',6:'<m-6>',7:'<m-7>',8:'<m-8>',9:'<m-9>'
                \,'t':'<m-t>','q':'<m-q>','a':'<m-a>','=':'<m-=>','h':'<m-h>','l':'<m-l>','j':'<m-j>','k':'<m-k>'
                \,'o':'<m-o>','-':'<m-->','b':'<m-b>','f':'<m-f>','m':'<m-m>','w':'<m-w>'}
endif

call TracyoneKeyMap('noremap',s:alt_char[1],'<esc>1gt')
call TracyoneKeyMap('noremap',s:alt_char[2],'<esc>2gt')
call TracyoneKeyMap('noremap',s:alt_char[3],'<esc>3gt')
call TracyoneKeyMap('noremap',s:alt_char[4],'<esc>4gt')
call TracyoneKeyMap('noremap',s:alt_char[5],'<esc>5gt')
call TracyoneKeyMap('noremap',s:alt_char[6],'<esc>6gt')
call TracyoneKeyMap('noremap',s:alt_char[7],'<esc>7gt')
call TracyoneKeyMap('noremap',s:alt_char[8],'<esc>8gt')
call TracyoneKeyMap('noremap',s:alt_char[9],'<esc>9gt')
"option+t
call TracyoneKeyMap('nnoremap',s:alt_char['t'],':tabnew<cr>')
call TracyoneKeyMap('inoremap',s:alt_char['t'],'<esc>:tabnew<cr>')
"option+q
call TracyoneKeyMap('noremap',s:alt_char['q'],':nohls<CR>:MarkClear<cr>:redraw!<cr>')
"select all
call TracyoneKeyMap('noremap',s:alt_char['a'],'gggH<C-O>G')
call TracyoneKeyMap('inoremap',s:alt_char['a'],'<C-O>gg<C-O>gH<C-O>G')
call TracyoneKeyMap('cnoremap',s:alt_char['a'],'<C-C>gggH<C-O>G')
call TracyoneKeyMap('onoremap',s:alt_char['a'],'<C-C>gggH<C-O>G')
call TracyoneKeyMap('snoremap',s:alt_char['a'],'<C-C>gggH<C-O>G')
call TracyoneKeyMap('xnoremap',s:alt_char['a'],'<C-C>ggVG')
"Alignment
call TracyoneKeyMap('nnoremap',s:alt_char['='],' <esc>ggVG=``')
"move
call TracyoneKeyMap('inoremap',s:alt_char['h'],'<Left>')
call TracyoneKeyMap('inoremap',s:alt_char['l'],'<Right>')
call TracyoneKeyMap('inoremap',s:alt_char['j'],'<Down>')
call TracyoneKeyMap('inoremap',s:alt_char['k'],'<Up>')

"move between windows
call TracyoneKeyMap('nnoremap',s:alt_char['h'],'  <C-w>h')
call TracyoneKeyMap('nnoremap',s:alt_char['l'],'<C-w>l')
call TracyoneKeyMap('nnoremap',s:alt_char['j'],'<C-w>j')
call TracyoneKeyMap('nnoremap',s:alt_char['k'],'<C-w>k')

call TracyoneKeyMap('cnoremap',s:alt_char['l'],'<right>')
call TracyoneKeyMap('cnoremap',s:alt_char['j'],'<down>')
call TracyoneKeyMap('cnoremap',s:alt_char['k'],'<up>')
call TracyoneKeyMap('cnoremap',s:alt_char['b'],'<S-left>')

call TracyoneKeyMap('nnoremap',s:alt_char['m'],':call MouseToggle()<cr>')   
" Mouse mode toggle
nnoremap <leader>tm :call te#utils#OptionToggle('mouse',['a',''])<cr>
" }}}

" GNU readline keybinding {{{
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap        <C-B> <Left>
inoremap        <C-f> <right>
"Delete the character underneath the cursor.
inoremap        <C-d> <BS>
"Delete the character underneath the cursor.
inoremap        <C-h> <BS>
cnoremap        <C-B> <Left>
cnoremap        <C-f> <right>
" Move forward a word or Move backward a word.
call TracyoneKeyMap('inoremap',s:alt_char['b'],'<S-left>')
call TracyoneKeyMap('inoremap',s:alt_char['f'],'<S-right>')
call TracyoneKeyMap('cnoremap',s:alt_char['f'],'<S-right>')
call TracyoneKeyMap('cnoremap',s:alt_char['h'],'<left>')

"move in cmd win
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>
noremap! <expr> <SID>transposition getcmdpos()>strlen(getcmdline())?"\<Left>":getcmdpos()>1?'':"\<Right>"
noremap! <expr> <SID>transpose "\<BS>\<Right>".matchstr(getcmdline()[0 : getcmdpos()-2], '.$')
cmap   <script> <C-T> <SID>transposition<SID>transpose

" }}}
"update the _vimrc
nnoremap <leader>so :call te#utils#SourceRc($MYVIMRC)<cr>
"open the vimrc in tab
nnoremap <leader>vc :tabedit $MYVIMRC<CR>

"clear search result

"save file 
"in terminal ctrl-s is used to stop printf..
noremap <C-S>	:call te#utils#SaveFiles()<cr>
vnoremap <C-S>	<C-C>:call te#utils#SaveFiles()<cr>
inoremap <C-S>	<C-O>:call te#utils#SaveFiles()<cr>

"copy,paste and cut 
noremap <S-Insert> "+gP
inoremap <c-v>	<C-o>"+gp
cmap <C-V>	<C-R>+
cmap <S-Insert>	<C-R>+
vnoremap <C-X> "+x


" CTRL-C and SHIFT-Insert are Paste
vnoremap <C-C> "+y

"change the windows size,f9, f10, f11, f12 --> hj, j, k, l
noremap <silent> <C-F9> :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>
" vertical increase window's size
noremap <silent> <leader>w. :vertical resize +10<CR>
" vertical decrease window's size
noremap <silent> <leader>w, :vertical resize -10<CR>
" horizontal decrease window's size
noremap <silent> <leader>w- :resize -10<CR>
" horizontal increase window's size
noremap <silent> <leader>w= :resize +10<CR>


"replace
nnoremap <c-h> :OverCommandLine<cr>:%s/<C-R>=expand("<cword>")<cr>/
vnoremap <c-h> :OverCommandLine<cr>:<c-u>%s/<C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>/
"delete the ^M
nnoremap dm :%s/\r\(\n\)/\1/g<CR>

"cd to current buffer's path
nnoremap <silent> <leader>fc :call GotoCurFile()<cr> 
nnoremap <silent> <c-F7> :call GotoCurFile()<cr> 

nnoremap <F7> :call Dosunix()<cr>:call te#utils#EchoWarning("Dos2unix...")<cr>
" dos to unix or unix to dos
nnoremap <Leader>td :call Dosunix()<cr>:call te#utils#EchoWarning("Dos2unix...")<cr>
" open url on cursor with default browser
nnoremap <leader>o :call Open_url()<cr>
" linu number toggle
nnoremap <Leader>tn :call TracyoneNuToggle()<cr>

"}}}
"Function{{{
function! TracyoneFindMannel()
    let l:man_cmd='Man'
    let l:cur_word=expand('<cword>')
    let l:ret = te#utils#GetError(l:man_cmd.' 3 '.l:cur_word,'no manual.*')
    "make sure index valid
    if l:ret != 0
        let l:ret = te#utils#GetError(l:man_cmd.' 2 '.l:cur_word,'no manual.*')
        if l:ret != 0
            execute 'silent! help '.l:cur_word
        endif
    else
        execute l:man_cmd.' 2 '.l:cur_word
    endif
endfunction

function! TracyoneCodingStypeToggle()
    if &tabstop != 8
        set tabstop=8  
        set shiftwidth=8 
        set softtabstop=8 
        set noexpandtab
        set nosmarttab
        call te#utils#EchoWarning('change to linux kernel coding style ...')
    else
        set tabstop=4  
        set shiftwidth=4 
        set softtabstop=4 
        set expandtab
        set smarttab
        call te#utils#EchoWarning('Use space instead of tab ...')
    endif
endfunction



function! s:Get_pattern_at_cursor(pat)
    let col = col('.') - 1
    let line = getline('.')
    let ebeg = -1
    let cont = match(line, a:pat, 0)
    while (ebeg >= 0 || (0 <= cont) && (cont <= col))
        let contn = matchend(line, a:pat, cont)
        if (cont <= col) && (col < contn)
            let ebeg = match(line, a:pat, cont)
            let elen = contn - ebeg
            break
        else
            let cont = match(line, a:pat, contn)
        endif
    endwhile
    if ebeg >= 0
        return strpart(line, ebeg, elen)
    else
        return ''
    endif
endfunction

function! GotoCurFile()
    execute 'lcd %:h'
    execute ':call te#utils#EchoWarning("cd to ".getcwd())'
endfunction
function! Open_url()
    let s:url = s:Get_pattern_at_cursor('\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?')
    if s:url ==? ''
        echohl WarningMsg
        echomsg 'It is not a URL on current cursor！'
        echohl None
    else
        echo 'Open URL：' . s:url
        if has('win32') || has('win64')
            call system('cmd /C start ' . s:url)
        elseif has('mac')
            call system("open '" . s:url . "'")
        else
            call system("xdg-open '" . s:url . "' &")
        endif
    endif
    unlet s:url
endfunction

function! s:CmdLine(str)
    exe 'menu Foo.Bar :' . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

func! Dosunix()
    if &ff ==# 'unix'
        exec 'se ff=dos'
    else
        exec 'se ff=unix'
    endif
endfunc


function! TracyoneGotoDef(open_type)
    let l:cword=expand('<cword>')
    execute a:open_type
    if te#env#SupportYcm() && s:complete_plugin == 1
        let l:ycm_ret=s:YcmGotoDef(a:open_type)
    else
        let l:ycm_ret = -1
    endif
    if l:ycm_ret < 0
        try
            execute 'cs find g '.l:cword
        catch /^Vim\%((\a\+)\)\=:E/	
            call te#utils#EchoWarning('cscope query failed')
            if a:open_type !=? '' | wincmd q | endif
            return -1
        endtry
    else
        return 0
    endif
    return 0
endfunction

func! s:YcmGotoDef(open_type)
    let l:cur_word=expand('<cword>').'\s*(.*[^;]$'
    if s:complete_plugin == 1 
        if  exists('*youcompleteme#Enable') == 0
            call te#utils#EchoWarning('Loading ycm ...')
            call plug#load('ultisnips','YouCompleteMe')
            call delete('.ycm_extra_conf.pyc')  
            call youcompleteme#Enable() 
            let g:is_load_ycm = 1
            autocmd! lazy_load_group 
            sleep 1
            call te#utils#EchoWarning('ycm has been loaded!')
        endif
    endif
    let l:ret = te#utils#GetError(':YcmCompleter GoToDefinition','Runtime.*')
    if l:ret == -1
        let l:ret = te#utils#GetError(':YcmCompleter GoToDeclaration','Runtime.*')
        if l:ret == 0
            execute ':silent! A'
            " search failed then go back
            if search(l:cur_word) == 0
                execute ':silent! A'
                return -2
            endif
        else
            return -3 
        endif
    endif
    return 0
endfunc

" line number toggle
function! TracyoneNuToggle()
    if &nu && &rnu
        set nonu nornu
    elseif &nu && !&rnu
        set rnu
    else
        set nu
    endif
endfunction

"}}}
"Plugin setting{{{
" Vim-plug ------------------------{{{
let &rtp=&rtp.','.$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    if te#env#IsWindows()
        silent! exec ':!mkdir -p '.$VIMFILES.'\\autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'\\autoload'.'\\plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent! exec ':!mkdir -p '.$VIMFILES.'/autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'/autoload'.'/plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif
call plug#begin($VIMFILES.'/bundle')
Plug 'tracyone/a.vim'

if empty(glob($VIMFILES.'/.complete_plugin'))
    let s:complete_plugin = 1
else
    let s:complete_plugin=readfile($VIMFILES.'/.complete_plugin')[0]
endif

if s:complete_plugin == 5 && !te#env#IsNvim()
    let s:complete_plugin = 1
endif

if s:complete_plugin == 1
    if te#env#IsUnix()
        Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
        Plug 'Valloric/YouCompleteMe', { 'on': [] }
        let s:complete_plugin_name='YouCompleteMe'
    elseif te#env#IsWin32()
        Plug 'snakeleon/YouCompleteMe-x86', { 'on': [] }
        let s:complete_plugin_name='YouCompleteMe-x86'
    else
        Plug 'snakeleon/YouCompleteMe-x64', { 'on': [] }
        let s:complete_plugin_name='YouCompleteMe-x64'
    endif
elseif s:complete_plugin == 2
    Plug 'Rip-Rip/clang_complete'
elseif s:complete_plugin == 3
    Plug 'maralla/completor.vim'
elseif s:complete_plugin == 4
    Plug 'Shougo/neocomplete'
    Plug 'tracyone/dict'
    Plug 'Konfekt/FastFold'
elseif s:complete_plugin == 5
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
else
    call te#utils#EchoWarning('No complete plugin selected!')
endif
Plug 'Shougo/neco-vim'
Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'tracyone/hex2ascii.vim', { 'do': 'make' }
Plug 'thinca/vim-qfreplace'
Plug 'vim-scripts/verilog.vim',{'for': 'verilog'}
Plug 'easymotion/vim-easymotion', { 'on': [ '<Plug>(easymotion-lineforward)',
            \ '<Plug>(easymotion-linebackward)','<Plug>(easymotion-overwin-w)' ]}
Plug 'thinca/vim-quickrun'
"some awesome vim colour themes
if te#env#IsGui()
    Plug 'thinca/vim-fontzoom',{'on': ['<Plug>(fontzoom-smaller)', '<Plug>(fontzoom-larger)'] }
endif
Plug 'sjl/badwolf'
Plug 'iCyMind/NeoSolarized'
Plug 'cocopon/iceberg.vim'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'KabbAmine/yowish.vim'
Plug 'rakr/vim-one'
Plug 'zanglg/nova.vim'
"some productive plugins
Plug 'terryma/vim-multiple-cursors'
if te#env#SupportPy()
    Plug 'ashisha/image.vim'
endif
Plug 'terryma/vim-expand-region'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky',{'on': 'CtrlPFunky'}
Plug 'fisadev/vim-ctrlp-cmdpalette',{'on': 'CtrlPCmdPalette'}
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'jaxbot/github-issues.vim', { 'on': 'Gissue' }
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/genutils'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}
Plug 'arecarn/selection.vim' | Plug 'arecarn/crunch.vim',{'on':'Crunch'}
Plug 'mhinz/vim-startify'
Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'tracyone/snippets'
Plug 'ianva/vim-youdao-translater', {'do': 'pip install requests --user','on': ['Ydc','Ydv']}
Plug 'iamcco/markdown-preview.vim',{'for': 'markdown'}
Plug 'mzlogin/vim-markdown-toc',{'for': 'markdown'}
Plug 'plasticboy/vim-markdown',{'for': 'markdown'}
Plug 'rhysd/vim-clang-format',{'for': ['c', 'cpp']}
if(!te#env#IsWindows())
    if te#env#IsTmux()
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'lucidstack/ctrlp-tmux.vim',{'on': 'CtrlPTmux'}
        Plug 'jebaum/vim-tmuxify'
    endif
    Plug 'tracyone/ctrlp-leader-guide'
    Plug 'vim-scripts/sudo.vim'
    if !te#env#IsNvim() | Plug 'vim-utils/vim-man' | endif
    Plug 'tracyone/pyclewn_linux',{'branch': 'pyclewn-1.11'}
    if te#env#IsMac()
        Plug 'CodeFalling/fcitx-vim-osx',{'do': 'wget -c \"https://raw.githubusercontent.com/
                    \CodeFalling/fcitx-remote-for-osx/binary/fcitx-remote-sogou-pinyin\" && 
                    \chmod a+x fcitx* && mv fcitx* /usr/local/bin/fcitx-remote'}
    else
        Plug 'CodeFalling/fcitx-vim-osx'
    endif
endif
if !te#env#IsNvim() 
    if te#env#IsMac()
        Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
    elseif te#env#IsUnix()
        Plug 'Shougo/vimproc.vim', { 'do': 'make' }
    else
        Plug 'Shougo/vimproc.vim', { 'do': 'mingw32-make.exe -f make_mingw64.mak' }
    endif
    Plug 'Shougo/vimshell.vim',{'on':'VimShell'}
    Plug 'tracyone/YankRing.vim'
else
    Plug 'mattn/ctrlp-register',{'on': 'CtrlPRegister'}
endif
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'hecal3/vim-leader-guide'
Plug 'mbbill/undotree',  { 'on': 'UndotreeToggle'   }
Plug 'vim-scripts/L9'
Plug 'mattn/emmet-vim',{'for': 'html'}
Plug 'junegunn/vim-easy-align',{'on': [ '<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)' ]}
Plug 'adah1972/fencview',{'on': 'FencManualEncoding'}
Plug 'vim-scripts/DrawIt',{'on': 'DrawIt'}
Plug 'mbbill/VimExplorer',{'on': 'VE'}
Plug 'vim-scripts/renamer.vim',{'on': 'Ren'}
Plug 'hari-rangarajan/CCTree'
Plug 'tracyone/mark.vim'
Plug 'tpope/vim-repeat' "repeat enhance
Plug 'Shougo/vinarise.vim',{'on': 'Vinarise'}
Plug 'tracyone/love.vim'
Plug 't9md/vim-choosewin'
Plug 'itchyny/vim-cursorword'
Plug 'justinmk/vim-gtfo' "got to file explorer or terminal
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'osyo-manga/vim-over'
Plug 'rhysd/github-complete.vim'
if te#env#IsVim8() || te#env#IsNvim()
    "Plug 'skywind3000/asyncrun.vim',{'on': 'AsyncRun'}
    Plug 'neomake/neomake'
    Plug 'tracyone/neomake-multiprocess'
endif
" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
call plug#end()
autocmd misc_group VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   echom '[t-vim]Need to install the missing plugins!'
            \|   PlugInstall --sync | q
            \| endif
"}}}

" Tohtml --------------------------{{{
let html_use_css=1
let g:user_emmet_leader_key = '<c-e>'
"}}}

" Tagbar --------------------------{{{
nnoremap <silent><F9> :TagbarToggle<CR>
" Open tagbar
nnoremap <leader>tt :TagbarToggle<CR>
let g:tagbar_left=0
let g:tagbar_width=30
let g:tagbar_sort=0
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_systemenc='cp936'
"}}}

" Complete ------------------------{{{
"generate .ycm_extra_conf.py for current directory

" lazyload ultisnips and YouCompleteMe
if s:complete_plugin == 1
    augroup lazy_load_group
        autocmd!
        autocmd InsertEnter * call plug#load('ultisnips',s:complete_plugin_name)
                    \| call delete('.ycm_extra_conf.pyc')  | call youcompleteme#Enable() 
                    \| autocmd! lazy_load_group
    augroup END
else
    augroup lazy_load_group
        autocmd!
        autocmd InsertEnter * call plug#load('ultisnips')
                    \| autocmd! lazy_load_group
    augroup END

endif

" autoclose preview windows
autocmd misc_group InsertLeave * if pumvisible() == 0|pclose|endif

if s:complete_plugin == 1
    function! GenYCM()
        let l:cur_dir=getcwd()
        cd $VIMFILES/bundle/YCM-Generator
        :silent execute  ':!./config_gen.py '.l:cur_dir
        if v:shell_error == 0
            echom 'Generate successfully!'
            :YcmRestartServer
        else
            echom 'Generate failed!'
        endif
        exec ':cd '. l:cur_dir
    endfunction
    " jume to definition (YCM)
    nnoremap <leader>jl :YcmCompleter GoToDeclaration<CR>
    let g:ycm_confirm_extra_conf=0
    let g:syntastic_always_populate_loc_list = 1
    let g:ycm_semantic_triggers = {
                \   'c' : ['->', '    ', '.', ' ', '(', '[', '&'],
                \     'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
                \     'perl' : ['->', '::', ' '],
                \     'php' : ['->', '::', '.'],
                \     'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
                \     'ruby' : ['.', '::'],
                \     'lua' : ['.', ':'],
                \     'vim' : ['$', '&', 're![\w&$<-][\w:#<>-]*']
                \ }

    let g:ycm_collect_identifiers_from_tag_files = 1
    let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'startufy' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'mail' : 1
                \}
    let g:ycm_global_ycm_extra_conf = $VIMFILES . '/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
elseif s:complete_plugin == 4
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#data_directory = $VIMFILES . '/.neocomplete'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'cpp' : $VIMFILES.'/bundle/dict/cpp.dict',
                \ 'html' : $VIMFILES.'/bundle/dict/html.dict',
                \ 'c' : $VIMFILES.'/bundle/dict/c.dict',
                \ 'sh' : $VIMFILES.'/bundle/dict/bash.dict',
                \ 'dosbatch' : $VIMFILES.'/bundle/dict/batch.dict',
                \ 'tex' : $VIMFILES.'/bundle/dict/latex.dict',
                \ 'vim' : $VIMFILES.'/bundle/dict/vim.dict.txt',
                \ 'verilog' : $VIMFILES.'/bundle/dict/verilog.dict'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    " <TAB>: completion.
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    "imap <expr> `  pumvisible() ? "\<Plug>(neocomplete_start_unite_quick_match)" : '`'
    " Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
	endif
	let g:neocomplete#sources#omni#input_patterns.php =
	\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    " For smart TAB completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
           \ <SID>check_back_space() ? "\<TAB>" :
           \ neocomplete#start_manual_complete()
     function! s:check_back_space() 
       let col = col('.') - 1
       return !col || getline('.')[col - 1]  =~# '\s'
     endfunction
 elseif s:complete_plugin == 2 
     " clang_complete
     " path to directory where library can be found
     if te#env#IsMac()
         let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
     elseif te#env#IsUnix()
         let g:clang_library_path='/usr/local/lib'
     endif
     "let g:clang_use_library = 1
     let g:clang_complete_auto = 1
     let g:clang_debug = 1
     let g:clang_snippets=1
     let g:clang_complete_copen=0
     let g:clang_periodic_quickfix=1
     "let g:clang_snippets_engine="ultisnips"
     let g:clang_close_preview=1
     "let g:clang_jumpto_declaration_key=""
     "g:clang_jumpto_declaration_in_preview_key
     inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
elseif s:complete_plugin == 3 
    "completor.vim 
    let g:completor_clang_binary = '/usr/bin/clang'
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
elseif s:complete_plugin == 5 
    "deoplete
     if te#env#IsMac()
         let g:deoplete#sources#clang#libclang_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
         let g:deoplete#sources#clang#clang_header='/Library/Developer/CommandLineTools/usr/lib/clang/8.0.0/include/'
     elseif te#env#IsUnix()
         let g:deoplete#sources#clang#libclang_path='/usr/local/lib/libclang.so'
     endif
    let g:deoplete#enable_at_startup = 1
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
    let g:deoplete#sources#clang#flags=[]
    function! TracyoneAddCFlags(dir)
        let l:dir=a:dir.'/'
        if strlen(a:dir) == 0
            let l:dir=getcwd().'/'
        endif
        if empty(glob(l:dir.'.clang_complete'))
           return 1 
        else
            for s:line in readfile(l:dir.'.clang_complete', '')
                :call add(g:deoplete#sources#clang#flags,matchstr(s:line,"\\v[^']+"))
            endfor
        endif
        return 0
    endfunction
    :call TracyoneAddCFlags('')
endif
"}}}

" Matchit.vim ---------------------{{{
"extend %
runtime macros/matchit.vim "important 
let loaded_matchit=0
let b:match_ignorecase=1 
set mps+=<:>
set mps+=":"
"}}}

" Nerdtree  -----------------------{{{
let NERDTreeShowLineNumbers=0	"don't show line number
let NERDTreeWinPos='left'	"show nerdtree in the rigth side
"let NERDTreeWinSize='30'
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
noremap <F12> :NERDTreeToggle .<CR> 
" Open nerd tree
nnoremap <leader>te :NERDTreeToggle .<CR> 
"map <2-LeftMouse>  *N "double click highlight the current cursor word 
inoremap <F12> <ESC> :NERDTreeToggle<CR>
"}}}

" A.vim ---------------------------{{{
":A switches to the header file corresponding to the current file being  edited (or vise versa)
":AS splits and switches
":AV vertical splits and switches
":AT new tab and switches
":AN cycles through matches
":IH switches to file under cursor
":IHS splits and switches
":IHV vertical splits and switches
":IHT new tab and switches
":IHN cycles through matches
" Open c family header in new tab
nnoremap <leader>iav :AT<cr>
"}}}

" DelimitMate ---------------------{{{
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 0
let delimitMate_expand_space = 0
"}}}

" yankring ------------------------{{{
if !te#env#IsNvim()
    nnoremap <c-y> :YRGetElem<CR>
    inoremap <c-y> <esc>:YRGetElem<CR>
    " Open yankring window
    nnoremap <Leader>yy :YRGetElem<CR>
else
    nnoremap <c-y> :CtrlPRegister<cr>
    inoremap <c-y> <esc>:CtrlPRegister<cr>
    " Open CtrlPRegister
    nnoremap <Leader>yy :CtrlPRegister<cr>
endif
let yankring_history_dir = $VIMFILES
let g:yankring_history_file = '.yank_history'
let g:yankring_default_menu_mode = 0
let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'
"}}}

" CCtree --------------------------{{{
let g:CCTreeKeyTraceForwardTree = '<C-\>>' "the symbol in current cursor's forward tree 
let g:CCTreeKeyTraceReverseTree = '<C-\><'
let g:CCTreeKeyHilightTree = '<C-\>l' " Static highlighting
let g:CCTreeKeySaveWindow = '<C-\>y'
let g:CCTreeKeyToggleWindow = '<C-\>w'
let g:CCTreeKeyCompressTree = 'zs' " Compress call-tree
let g:CCTreeKeyDepthPlus = '<C-\>='
let g:CCTreeKeyDepthMinus = '<C-\>-'
let CCTreeJoinProgCmd = 'PROG_JOIN JOIN_OPT IN_FILES > OUT_FILE'
let  g:CCTreeJoinProg = 'cat' 
let  g:CCTreeJoinProgOpts = ''
"let g:CCTreeUseUTF8Symbols = 1
"map <F7> :CCTreeLoadXRefDBFromDisk $CCTREE_DB<cr> 
"}}}

" Ctrlp ---------------------------{{{
" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_files = 50000

" Tell Ctrl-P to keep the current VIM working directory when starting a
" search, another really stupid non default
let g:ctrlp_working_path_mode = 'w'

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
" Ctrl-P ignore target dirs so VIM doesn't have to! Yay!
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|svn|hg|build|sass-cache)$',
            \ 'file': '\v\.(exe|so|dll|o|d|proj|out)$',
            \ }
let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'bookmarkdir']
if executable('ag')
    "NOTE: --ignore option use wildcard PATTERN instead of regex PATTERN,and
    "it does not support {}
    "--hidden:enable seach hidden dirs and files
    "-g <regex PATTERN>:search file name that match the PATTERN
    let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup 
                \ --ignore "*.[odODaA]"
                \ --ignore "*.exe"
                \ --ignore "*.out"
                \ --ignore "*.hex"
                \ --ignore "cscope*"
                \ --ignore "*.so"
                \ --ignore "*.dll"
                \ -g ""'
    let g:ctrlp_use_caching = 0
    let g:ctrlp_show_hidden = 1
    let g:user_command_async = 1
endif
let g:ctrlp_funky_syntax_highlight = 0
let g:ctrlp_funky_matchtype = 'path'
nnoremap <c-k> :CtrlPFunky<Cr>
nnoremap <c-j> :CtrlPBuffer<Cr>
" toggle ctrlp g:ctrlp_use_caching option
nnoremap <leader>tj :call te#utils#OptionToggle('g:ctrlp_use_caching',[0,1])<cr>
" show global mark
nnoremap <leader>pm :SignatureListGlobalMarks<Cr>
" ctrlp buffer 
nnoremap <Leader>pl :CtrlPBuffer<Cr>
nnoremap <c-l> :CtrlPMRUFiles<cr>
"CtrlP mru
nnoremap <Leader>pr :CtrlPMRUFiles<cr>
"CtrlP file
nnoremap <Leader>pp :CtrlP<cr>
" narrow the list down with a word under cursor
"CtrlP function 
nnoremap <Leader>pU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
"CtrlP cmd
nnoremap <Leader>pc :CtrlPCmdPalette<cr>
"CtrlP function
nnoremap <Leader>pk :CtrlPFunky<cr>
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
"}}}

" VimExplorer ---------------------{{{
let g:VEConf_systemEncoding = 'cp936'
noremap <F11> :silent! VE .<cr>
" Open Vim File Explorer
nnoremap <Leader>fj :silent! VE .<cr>
"}}}

" UltiSnips -----------------------{{{
if  te#env#SupportPy()
    let g:UltiSnipsUsePythonVersion = 2
else
    let g:UltiSnipsUsePythonVersion = 3 
endif
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsListSnippets ='<c-tab>'
let g:UltiSnipsJumpForwardTrigge='<c-j>'
let g:UltiSnipsJumpBackwardTrigge='<c-k>'
let g:UltiSnipsSnippetDirectories=['bundle/snippets']
let g:UltiSnipsSnippetsDir=$VIMFILES.'/bundle/snippets'
"}}}

" FencView ------------------------{{{
let g:fencview_autodetect=0 
let g:fencview_auto_patterns='*.txt,*.htm{l\=},*.c,*.cpp,*.s,*.vim'
function! FencToggle()
    if &fenc ==# 'utf-8'
        FencManualEncoding cp936
        call te#utils#EchoWarning('Chang encode to cp936')
    elseif &fenc ==# 'cp936'
        FencManualEncoding utf-8
        call te#utils#EchoWarning('Chang encode to utf-8')
    else
        call te#utils#EchoWarning('Current file encoding is '.&fenc)
    endif
endfunction
" Convert file's encode
nnoremap <leader>tf :call FencToggle()<cr>
"}}}

" Renamer -------------------------{{{
noremap <F2> :Ren<cr>
"rename multi file name
nnoremap <Leader>fR :Ren<cr>
"}}}

" Vimshell ------------------------{{{
if(!te#env#IsNvim())
    let g:vimshell_user_prompt = '":: " . "(" . fnamemodify(getcwd(), ":~") . ")"'
    "let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
    let g:vimshell_enable_smart_case = 1
    let g:vimshell_editor_command='gvim'
    if te#env#IsWindows()
        " Display user name on Windows.
        let g:vimshell_prompt = $USERNAME.'% '
    else
        " Display user name on Linux.
        let g:vimshell_prompt = $USER.'% '
    endif
    "let g:vimshell_popup_command='rightbelow 10split'
    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    silent! call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    let g:vimshell_temporary_directory = $VIMFILES . '/.vimshell'
    silent! call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
    augroup vimshell_group
        autocmd!
        au FileType vimshell :imap <buffer> <HOME> <Plug>(vimshell_move_head)
        au FileType vimshell :imap <buffer> <c-l> <Plug>(vimshell_clear)
        au FileType vimshell :imap <buffer> <c-p> <Plug>(vimshell_history_unite)
        au FileType vimshell :imap <buffer> <up> <Plug>(vimshell_history_unite)
        au FileType vimshell,neoman setlocal nonu nornu
        au FileType vimshell :imap <buffer> <c-d> <Plug>(vimshell_exit)
        au FileType vimshell :imap <buffer> <c-j> <Plug>(vimshell_enter)
        au Filetype vimshell  setlocal completefunc=vimshell#complete#omnifunc omnifunc=vimshell#complete#omnifunc
        autocmd FileType vimshell
                    \ call vimshell#altercmd#define('g', 'git')
                    \| call vimshell#altercmd#define('i', 'iexe')
                    \| call vimshell#altercmd#define('l', 'll')
                    \| call vimshell#altercmd#define('gtab', 'gvim --remote-tab')
                    \| call vimshell#altercmd#define('c', 'clear')
        "\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

        "function! g:my_chpwd(args, context)
        "call vimshell#execute('ls')
        "endfunction

        autocmd FileType int-* call s:interactive_settings()
    augroup END
    function! s:interactive_settings()
    endfunction
endif

function! TracyoneVimShellPop()
    let l:line=(38*&lines)/100
    if  l:line < 10 | let l:line = 10 |endif
    execute 'rightbelow '.l:line.'split'
    if te#env#IsNvim() | execute 'terminal' | else | execute 'VimShell' | endif
endfunction
noremap <F4> :call TracyoneVimShellPop()<cr>
" Open vimshell or neovim's emulator
nnoremap <Leader>as :call TracyoneVimShellPop()<cr>
"}}}

" Nerdcommander -------------------{{{
let g:NERDMenuMode=0
let NERD_c_alt_style=1
"}}}

" VimStartify ---------------------{{{
if te#env#IsWindows()
    let g:startify_session_dir = $VIMFILES .'\sessions'
else
    let g:startify_session_dir = $VIMFILES .'/sessions'
endif
let g:startify_list_order = [
            \ ['   These are my sessions:'],
            \ 'sessions',
            \ ['   My most recently used files in the current directory:'],
            \ 'dir',
            \ ['   My most recently used files:'],
            \ 'files',
            \ ]
let g:startify_change_to_dir = 1
let g:startify_files_number = 5 
let g:startify_change_to_vcs_root = 0
let g:startify_custom_header = [
            \ '       __             _         ',
            \ '      / /_     _   __(_)___ ___ ',
            \ '     / __/____| | / / / __ `__ \',
            \ '    / /_/_____/ |/ / / / / / / /',
            \ '    \__/      |___/_/_/ /_/ /_/ ',
            \ '                                ',                            
            \ '    <space>hk open keymap list',
            \ '    <space>vc open vimrc in new tab',
            \ '    author:tracyone at live dot cn',
            \ '',
            \ '',
            \ ]

noremap <F8> :SSave<cr>
" Open startify windows
nnoremap <Leader>bh :Startify<cr>
autocmd misc_group FileType startify setlocal buftype=
"}}}

" GlobalSearch --------------------{{{
"ag search c family function
nnoremap <leader>vf :call neomakemp#global_search(expand("<cword>") . "\\s*\\([^()]*\\)\\s*[^;]")<cr>
"set grepprg=ag\ --nogroup\ --nocolor
"set grepformat=%f:%l:%c%m
autocmd misc_group FileType qf nnoremap <buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR>
autocmd misc_group FileType gitcommit,qfreplace setlocal nofoldenable
"}}}

" Markdown ------------------------{{{
if  te#env#IsMac()
    let g:mkdp_path_to_chrome = 'open -a safari'
elseif te#env#IsWindows()
    let g:mkdp_path_to_chrome = 'C:\\Program Files (x86)\Google\Chrome\Application\chrome.exe'
else
    let g:mkdp_path_to_chrome = 'google-chrome'
endif
let g:vim_markdown_toc_autofit = 1
" Markdown preview in browser
nnoremap <leader>mp :MarkdownPreview<cr>
" generate markdown TOC
nnoremap <leader>mt :silent GenTocGFM<cr>
" update markdown TOC
nnoremap <leader>mu :silent UpdateToc<cr>
" Show toc sidebar
nnoremap <leader>ms :Toc<cr>
"}}}

" Git releate ---------------------{{{
nnoremap <F3> :Gstatus<cr>
" Open git status window
nnoremap <Leader>gs :Gstatus<cr>
" Open github url
nnoremap <Leader>gh :Gbrowse<cr>
" Open git log( browser mode)
nnoremap <Leader>gl :Gitv --all<cr>
" Open git log(file mode)
nnoremap <Leader>gL :Gitv! --all<cr>
" Open git log(file mode)
vnoremap <leader>gL :Gitv! --all<cr>
" Open git blame windows
nnoremap <Leader>gb :Gblame<cr>
" git diff current file (vimdiff)
nnoremap <Leader>gd :Gdiff<cr>
" list git issue
nnoremap <Leader>gi :silent! Gissue<cr>
" create new github issue
nnoremap <Leader>ga :silent! Giadd<cr>
" git merge
nnoremap <Leader>gm :call te#git#git_merge()<cr>
let g:gissues_lazy_load = 1
let g:gissues_async_omni = 1
if filereadable($VIMFILES.'/.github_token')
    let g:github_access_token = readfile($VIMFILES.'/.github_token', '')[0]
endif
" git push origin master
nnoremap <Leader>gp :call te#git#GitPush("heads")<cr>
" git push to gerrit
nnoremap <Leader>gg :call te#git#GitPush("for")<cr>
" git fetch all
nnoremap <Leader>gf :call neomakemp#run_command('git fetch --all')<cr>
"}}}

" Vim-multiple-cursors ------------{{{
" }}}

" Easymotion ----------------------{{{
map W <Plug>(easymotion-lineforward)
map B <Plug>(easymotion-linebackward)
" MultiWindow easymotion for word
nmap <Leader>F <Plug>(easymotion-overwin-w)
" Multi Input Find Motion:s
nmap <Leader>es <Plug>(easymotion-sn)
" Multi Input Find Motion:t
nmap <Leader>et <Plug>(easymotion-tn)
" MultiWindow easymotion for line
nmap <Leader>el <Plug>(easymotion-overwin-line)
" MultiWindow easymotion for char
nmap <Leader>ef <Plug>(easymotion-overwin-f)

let g:EasyMotion_startofline = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_verbose = 0
" }}}

" Tmux ------------------{{{
if te#env#IsTmux()
    let g:tmux_navigator_no_mappings = 1
    exec 'nnoremap <silent> '.s:alt_char['h'] .' :TmuxNavigateLeft<cr>'
    exec 'nnoremap <silent> '.s:alt_char['l'].' :TmuxNavigateRight<cr>'
    exec 'nnoremap <silent>'.s:alt_char['j'].' :TmuxNavigateDown<cr>'
    exec 'nnoremap <silent> '.s:alt_char['k']. ' :TmuxNavigateUp<cr>'
    exec 'nnoremap <silent> '.s:alt_char['w']. ' :TmuxNavigatePrevious<cr>'
    "CtrlP tmux window
    nnoremap <Leader>uu :CtrlPTmux w<cr>
    "CtrlP tmux buffer
    nnoremap <Leader>uf :CtrlPTmux b<cr>
    "CtrlP tmux session
    nnoremap <Leader>um :CtrlPTmux<cr>
    "CtrlP tmux command
    nnoremap <Leader>ud :CtrlPTmux c<cr>
    "CtrlP tmux command interactively
    nnoremap <Leader>ui :CtrlPTmux ci<cr>
    "let g:tmuxify_custom_command = 'tmux split-window -p 20'
    let g:tmuxify_map_prefix = '<leader>u'
endif
" }}}

" Algin ---------------------------{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap <leader>al <Plug>(LiveEasyAlign)
" Live easy align
nmap <leader>al <Plug>(LiveEasyAlign)
if !exists('g:easy_align_delimiters')
    let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
" }}}

" Quickrun ------------------------{{{
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'message',
            \   },
            \}

let g:quickrun_no_default_key_mappings = 1
map <F6> <Plug>(quickrun)
vnoremap <F6> :'<,'>QuickRun<cr>
" run cunrrent file
nmap <leader>yr <Plug>(quickrun)
" run selection text
vnoremap <leader>yr :'<,'>QuickRun<cr>
" }}}

" Incsearch -----------------------{{{
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
" }}}

" syntax check -------------------{{{
let g:neomake_make_maker = {
            \ 'exe': 'make',
            \ 'args': ['-j8'],
            \ 'errorformat': '%f:%l:%c: %m',
            \ }
" }}}
" Misc ---------------------------{{{
let g:fml_all_sources = 1
let g:asyncrun_bell=1
command! -bang -nargs=* -complete=file Make Neomake! <args>
exec 'map ' .s:alt_char['o'] .' :Fontzoom!<cr>'
exec 'map ' .s:alt_char['-'] .' <Plug>(fontzoom-smaller)'
exec 'map ' .s:alt_char['='] .' <Plug>(fontzoom-larger)'

autocmd misc_group VimEnter * :let g:cursorword = 0

"remove mapping of * and # in mark.vim
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
nmap <leader>mm <Plug>MarkSet
xmap <Leader>mm <Plug>MarkSet
nmap <leader>mr <Plug>MarkRegex
xmap <Leader>mr <Plug>MarkRegex
nmap <leader>mn <Plug>MarkClear
xmap <leader>mn <Plug>MarkClear
nmap <leader>m? <Plug>MarkSearchAnyPrev
nmap <leader>m/ <Plug>MarkSearchAnyNext


" realtime underline word toggle
nnoremap <leader>th :call te#utils#OptionToggle("g:cursorword",[0,1])<cr>
" YouDao translate
nnoremap <Leader>ay <esc>:Ydc<cr>
" YouDao translate (visual mode)
vnoremap <Leader>ay <esc>:Ydv<cr>
nnoremap <F10> <esc>:Ydc<cr>
vnoremap <F10> <esc>:Ydv<cr>
" vim calculator
nnoremap <Leader>ac :Crunch<cr>
" undo tree window toggle
nnoremap <leader>tu :UndotreeToggle<cr>
"hex to ascii convert
nnoremap <leader>ah :call Hex2asciiConvert()<cr>
" next buffer or tab
nnoremap <Leader>bn :bnext<cr>
" previous buffer or tab
nnoremap <Leader>bp :bprev<cr>
" delete buffer
nnoremap <Leader>bk :bdelete<cr>
" open current file's position with default file explorer
nmap <Leader>af gof
" open current file's position with default terminal
nmap <Leader>at got
" open project's(pwd) position with default file explorer
nmap <Leader>aF goF
" open project's(pwd) position with default terminal
nmap <Leader>aT goT
" save file
nnoremap <Leader>fs :call te#utils#SaveFiles()<cr>
" save all
nnoremap <Leader>fS :wa<cr>
" manpage or vimhelp on current curosr word
nnoremap <Leader>hm :call TracyoneFindMannel()<cr>
" open eval.txt
nnoremap <Leader>he :tabnew<cr>:h eval.txt<cr>:only<cr>
" open vim script help
nnoremap <Leader>hp :tabnew<cr>:h usr_41.txt<cr>:only<cr>
" open vim function list
nnoremap <Leader>hf :tabnew<cr>:h function-list<cr>:only<cr>

" quit all
nnoremap <Leader>qq :qa<cr>
" quit all without save
nnoremap <Leader>qQ :qa!<cr>
" save and quit all
nnoremap <Leader>qs :wqa<cr>
" open calendar
nnoremap <Leader>ad :Calendar<cr>
" toggle free writing in vim (Goyo)
nnoremap <Leader>to :Goyo<cr>
" tab 1
nnoremap <leader>1 1gt
" tab 2
nnoremap <leader>2 2gt
" tab 3
nnoremap <leader>3 3gt
" tab 4
nnoremap <leader>4 4gt
" tab 5
nnoremap <leader>5 5gt
" tab 6
nnoremap <leader>6 6gt
" tab 7
nnoremap <leader>7 7gt
" tab 8
nnoremap <leader>8 8gt
" tab 9
nnoremap <leader>9 9gt
" toggle coding style 
nnoremap <leader>tc :call TracyoneCodingStypeToggle()<cr>
function! DrawItToggle()
    let l:ret = te#utils#GetError('DrawIt','already on')
    if l:ret != 0
        :DIstop
    else
        call te#utils#EchoWarning('Started DrawIt')
    endif
endfunction
" draw it
nnoremap <leader>aw :call DrawItToggle()<cr>

let g:love_support_option=['tabstop','shiftwidth','softtabstop'
            \,'expandtab','smarttab', 'termguicolors']
let g:SignatureEnabledAtStartup=1
" toggle long or short statusline
nnoremap <leader>ts :call te#utils#OptionToggle('statusline',['%!MyStatusLine(1)','%!MyStatusLine(2)'])<cr>
" toggle paste option
nnoremap <leader>tp :call te#utils#OptionToggle("paste",[1,0])<cr>
let g:bookmark_auto_save = 1
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
let g:bookmark_auto_close = 1
"Bookmark annotate
nnoremap <leader>mi :BookmarkAnnotate<CR>
"Bookmark toggle
nnoremap <leader>ma :BookmarkToggle<cr>
"Bookmark annotate 
vnoremap <leader>mi :<c-u>exec ':BookmarkAnnotate '.getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>
"Bookmark clear
nnoremap <leader>mc :BookmarkClear<cr>
"Bookmark show all
nnoremap <leader>mb :BookmarkShowAll<CR>
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
" Toggle termguicolors
nnoremap <Leader>tl :call te#utils#OptionToggle('termguicolors',[1,0])<cr>

" }}}

" Windows manger -----------------{{{
" vertical open window
nnoremap <Leader>wv :vsp<cr>
" vertical open window then focus the new one
nnoremap <Leader>wV :vsp<cr><C-w>l
" horizontal open window 
nnoremap <Leader>ws :sp<cr>
" horizontal open window then focus the new one
nnoremap <Leader>wS :sp<cr><C-w>j
" maxsize of current windows
nnoremap <Leader>wm :only<cr>
" quit current windows
nnoremap <Leader>wd :q<cr>
" switch between two windows.
nnoremap <Leader>ww <C-w><C-w>
let g:choosewin_overlay_enable = 1
" Choose windows
nmap <Leader>wc <Plug>(choosewin)
" move to left win
nnoremap <Leader>wh <C-w>h
" move to right win
nnoremap <Leader>wl <C-w>l
" move down win
nnoremap <Leader>wj <C-w>j
" move up win
nnoremap <Leader>wk <C-w>k
" Session save 
nnoremap <Leader>ls :SSave<cr>
" Session load
nnoremap <Leader>ll :SLoad 
" Save basic setting
nnoremap <Leader>lo :Love<cr>
" }}}

filetype plugin indent on
syntax on
"}}}
"Gui releate{{{
if te#env#IsGui()
    if (te#env#IsMac())
        set guifont=Consolas:h16
    elseif te#env#IsUnix()
        set guifont=Consolas\ 12
        set guifontwide=YaHei_Mono_Hybird_Consolas\ 12.5
    else
        set guifont=Monaco:h12:cANSI
        set guifontwide=YaHei_Mono:h12.5:cGB2312
    endif
    au misc_group GUIEnter * call s:MaximizeWindow()
    " turn on this option as well
    set guioptions-=b
    set guioptions-=m "whether use menu
    set guioptions-=r "whether show the rigth scroll bar
    set guioptions-=l "whether show the left scroll bar
    set guioptions-=T "whether show toolbar or not
    "highlight the screen line of the cursor
    func! MenuToggle()
        if &guioptions =~# '\a*[mT]\a*[mT]'
            :set guioptions-=T
            :set guioptions-=m
        else
            :set guioptions+=m
            :set guioptions+=T
        endif
    endfunc
    :call MenuToggle()
    nnoremap <c-F8> :call MenuToggle()<cr>
    " Menu and toolbar toggle(MacVIm and gvim)
    nnoremap <Leader>tg :call MenuToggle()<cr>
    set cul
    "toolbar ----------------- {{{
    if has('toolbar')
        if exists('*Do_toolbar_tmenu')
            delfun Do_toolbar_tmenu
        endif
        fun Do_toolbar_tmenu()
            tmenu ToolBar.Open		Open File
            tmenu ToolBar.Save		Save File
            tmenu ToolBar.SaveAll	Save All
            tmenu ToolBar.Print		Print
            tmenu ToolBar.Undo		Undo
            tmenu ToolBar.Redo		Redo
            tmenu ToolBar.Cut		Cut
            tmenu ToolBar.Copy		Copy
            tmenu ToolBar.Paste		Paste
            tmenu ToolBar.Find		Find&Replace
            tmenu ToolBar.FindNext	Find Next
            tmenu ToolBar.FindPrev	Find Prev
            tmenu ToolBar.Replace	Replace
            tmenu ToolBar.LoadSesn	Load Session
            tmenu ToolBar.SaveSesn	Save Session
            tmenu ToolBar.RunScript	Run a Vim Script
            tmenu ToolBar.Make		Make
            tmenu ToolBar.Shell		Shell
            tmenu ToolBar.RunCtags	ctags! -R
            tmenu ToolBar.TagJump	Jump to next tag
            tmenu ToolBar.Help		Help
            tmenu ToolBar.FindHelp	Search Help
        endfun
    endif
    "}}}
    "mouse ------------------- {{{
    " Set up the gui cursor to look nice
    set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
    amenu PopUp.-SEP3-	<Nop>
    ""extend", "popup" or "popup_setpos"; what the right
    set mousemodel=popup_setpos
    amenu PopUp.&Undo :UndotreeToggle<CR>
    amenu PopUp.&Goto\ Definition :cs find g <C-R>=expand("<cword>")<CR><CR>
    amenu PopUp.&Find\ Text :silent! execute "vimgrep " . expand("<cword>") . " **/*.[ch]". " **/*.cpp" . " **/*.cc"<cr>:cw 5<cr>
    amenu PopUp.&Open\ Header/Source :AT<cr>
    "}}}
    function! s:MaximizeWindow()
        if te#env#IsUnix()
            :win 1999 1999
            silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
        elseif te#env#IsWindows()
            :simalt~x "maximize window
        else
            :win 1999 1999
        endif
        ":set vb t_vb=
    endfunction
else
    set nocul
    set novb
    set t_vb=
    set t_ut=
    "highlight the screen line of the cursor
    set t_Co=256
endif

"{{{colorscheme
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0
set background=dark
try 
    colorscheme PaperColor "default setting 
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert "default setting 
endtry
" toggle background option.
nnoremap <leader>tb :call te#utils#OptionToggle("bg",["dark","light"])<cr>

"}}}
"}}}
"default is on but it is off when you are root,so we put it here
set modeline
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
