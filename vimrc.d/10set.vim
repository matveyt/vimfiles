" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" shell
if has('win32')
    let &shell = exepath('bash')->tr('\', '/')
    if empty(&shell)
        set shell&
    else
        set shellcmdflag=-c shellredir=>%s\ 2>&1 shellslash noshelltemp shellxescape=
        let &shellxquote = has('nvim') ? '' : '"'
        let [$CYGWIN, $MSYS] .= [' noglob', ' noglob']
    endif
endif

" misc. options
set autoread backspace=indent,eol,start belloff=all complete=.,w,b confirm
set diffopt+=vertical display+=lastline fillchars=vert:\ ,fold:\ ,diff:\ 
set fileformats=unix,dos grepformat=%f:%l:%c:%m history=1000 keywordprg=:Man
set guioptions-=t guioptions+=! guicursor+=a:blinkon0 linespace=1 lazyredraw
set modeline nrformats=alpha,bin,hex shortmess=cfilnxoOtTI pyxversion=3
set scrolloff=2 sidescroll=1 splitright ttimeout ttimeoutlen=50 wildmenu
set keymodel=startsel mousemodel=extend selection=exclusive selectmode=
set cursorline laststatus=2 mouse=ar number showmatch showtabline=2 title
set switchbuf=useopen tabpagemax=20 undofile virtualedit=all whichwrap+=<,>,[,]
set nobackup nowritebackup nofsync nohidden noequalalways noruler nostartofline
set noshowcmd noshowmode noswapfile viminfo=!,'100,<1000,s100,h
set sessionoptions=blank,curdir,help,slash,tabpages,unix,winsize suffixes&
set viewoptions=folds,cursor,curdir,slash,unix wildoptions=
let &grepprg = executable('ag') ? 'ag --vimgrep $* -- %:p:h:S' : 'internal'

" indents and folds
set autoindent nosmartindent formatoptions=tcroqj
set foldmethod=indent foldcolumn=1 foldlevel=3

" tabs, wraps and case
set nohlsearch nojoinspaces nowrap ignorecase incsearch infercase smartcase
set tabstop& expandtab nosmarttab softtabstop=-1 shiftround shiftwidth=4
set list listchars=tab:<->,trail:_ textwidth=89 colorcolumn=+1

" Russian keyboard and spelling
if v:lang =~? '^ru'
    set keymap=russian-jcukenwin spelllang=ru_yo,en
    set iminsert& imsearch& nolangremap
    lmap <bar> /
endif

" extra directories
call mkdir(better#stdpath('data', 'site/sessions'), 'p', 0700)
call mkdir(better#stdpath('data', 'site/templates'), 'p', 0700)
if &undodir is# '.'
    let &undodir = better#stdpath('data', 'site/undo')
    call mkdir(&undodir, 'p', 0700)
endif

" GVim menu bar
if has('gui_running')
    call better#defaults(#{do_no_lazyload_menus: 1, no_buffers_menu: 1})
endif

" disable standard plugins
call better#defaults(#{getscriptPlugin: 0, gzip: 0, logiPat: 0, netrwPlugin: 0,
    \ spellfile_plugin: 0, tarPlugin: 0, vimballPlugin: 0, zipPlugin: 0,
    \ 2html_plugin: 0}, 'loaded')
call better#defaults(has('nvim') ? #{node_provider: 0, perl_provider: 0,
    \ python_provider: 0, python3_provider: 0, ruby_provider: 0, remote_plugins: 0,
    \ shada_plugin: 0, tutor_mode_plugin: 0} : #{rrhelper: 0}, 'loaded')

" ftplugin config
call better#defaults(#{asmsyntax: 'fasm', is_bash: 1, no_pdf_maps: 1})
call better#defaults(#{gnu: 1, comment_strings: 1, no_space_errors: 1,
    \ no_curly_error: 1, syntax_for_h: 1}, 'c')
call better#defaults(#{fold_enabled: 7}, 'sh')
call better#defaults(#{conceal: '', flavor: 'latex'}, 'tex')
call better#defaults(#{indent_cont: shiftwidth(), json_conceal: 0}, 'vim')
call better#defaults(#{embed: 'l', folding: 'afl', noerror: 1}, 'vimsyn')

" other plugin config
call better#defaults(#{nl: 'nN'}, 'targets')
call better#defaults(#{WindowLayout: 4}, 'undotree')
call better#defaults(#{cache_directory: better#stdpath('data', 'site/unicode'),
    \ data_directory: better#stdpath('data', 'site/unicode')}, 'Unicode')
