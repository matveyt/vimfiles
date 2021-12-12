" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

compiler! gcc
set shell=bash shellcmdflag=-c shellredir=>%s\ 2>&1 shellslash shelltemp&
set shellquote= shellxescape= shellxquote=
if has('win32')
    set noshelltemp
    let &shellxquote = has('nvim') ? '' : '"'
    let $CYGWIN = 'noglob'
    let $MSYS = 'noglob'
endif

" move cursor and press 'K' to get help on option
set autoread backspace=indent,eol,start belloff=all complete=.,w,b confirm
set diffopt+=vertical display+=lastline fillchars=vert:\ ,fold:\ ,diff:\ 
set fileformats=unix,dos grepformat=%f:%l:%c:%m history=1000 keywordprg=:Man
set guioptions-=t guioptions+=! guicursor+=a:blinkon0 linespace=1
set lazyredraw nrformats=alpha,bin,hex shortmess=cfilnxoOtTI pyxversion=3
set scrolloff=2 sidescroll=1 splitright ttimeout ttimeoutlen=50 wildmenu
set keymodel=startsel mousemodel=extend selection=exclusive selectmode=
set cursorline laststatus=2 mouse=ar number showmatch showtabline=2 title
set switchbuf=useopen tabpagemax=20 undofile virtualedit=all whichwrap+=<,>,[,]
set nobackup nowritebackup nofsync nohidden nolangremap noruler noshowcmd
set noshowmode nostartofline noswapfile viminfo=!,'100,<1000,s100,h
set sessionoptions=blank,curdir,help,slash,tabpages,unix,winsize
set viewoptions=folds,cursor,curdir,slash,unix wildoptions=
call better#safe('set scrollfocus')
let &grepprg = executable('ag') ? 'ag --vimgrep $* -- %:p:h:S' : 'internal'
if &undodir is# '.'
    let &undodir = better#stdpath('data', 'site/undo')
    call mkdir(&undodir, 'p', 0700)
endif

" indents and folds
set autoindent nosmartindent formatoptions=tcroqj matchpairs+=<:>
set foldmethod=indent foldcolumn=1 foldlevel=3

" tabs, wraps and case
set nohlsearch nojoinspaces nowrap ignorecase incsearch infercase smartcase
set tabstop& expandtab nosmarttab softtabstop=-1 shiftround shiftwidth=4
set list listchars=tab:<->,trail:_,nbsp:+ textwidth=89 colorcolumn=+1

" Russian keyboard and spelling
if v:lang =~? '^ru'
    set keymap=russian-jcukenwin spelllang=ru_yo,en
    set iminsert& imsearch&
endif

" GVim menu bar
if has('gui_running')
    let g:do_no_lazyload_menus = 1
    let g:no_buffers_menu = 1
endif

" ftplugin config
call better#defaults(v:null, #{asmsyntax: 'fasm', is_bash: 1, no_pdf_maps: 1})
call better#defaults('c', #{gnu: 1, comment_strings: 1, no_space_errors: 1,
    \ no_curly_error: 1, syntax_for_h: 1})
call better#defaults('sh', #{fold_enabled: 7})
call better#defaults('tex', #{conceal: '', flavor: 'latex'})
call better#defaults('vim', #{indent_cont: shiftwidth(), json_conceal: 0})
call better#defaults('vimsyn', #{embed: 'l', folding: 'afl', noerror: 1})

" other plugin config
call better#defaults('targets', #{nl: 'nN'})
call better#defaults('undotree', #{WindowLayout: 4})
