" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

" Vim options
set autoindent autoread backspace=indent,eol,start nobackup belloff=all clipboard&
set colorcolumn=+1 complete=.,w,b completeopt& confirm cursorline diffopt+=vertical
set display=lastline noequalalways expandtab fileformats=unix,dos
set fillchars=vert:\ ,fold:\ ,diff:\  foldcolumn=1 foldlevel=3 foldmethod=indent
set formatoptions=tcroqj nofsync grepformat=%f:%l:%c:%m
let &grepprg = executable('ag') ? 'ag --vimgrep $* -- %:p:h:S' : 'internal'
set guicursor+=a:blinkon0 nohidden history=500 hlsearch ignorecase incsearch infercase
set nojoinspaces keymodel=startsel keywordprg=:Man laststatus=2 lazyredraw linespace=1
set list listchars=tab:<->,trail:_ modeline mouse=ar mousemodel=extend nrformats=bin,hex
set number pyxversion=3 noruler scrolloff=2 selection=exclusive selectmode&
set sessionoptions=blank,curdir,help,slash,tabpages,unix,winsize shiftround shiftwidth=4
set shortmess=cfiIlnoOtTx showcmd showcmdloc=statusline showmatch noshowmode
set showtabline=2 sidescroll=1 sidescrolloff=0 signcolumn& smartcase nosmartindent
set nosmarttab softtabstop=-1 nosplitbelow splitright nostartofline suffixes& noswapfile
set switchbuf=useopen tabpagemax=20 tabstop& textwidth=89 timeout& timeoutlen& title
set ttimeout ttimeoutlen=50 undofile viewoptions=folds,curdir,cursor,slash,unix
set viminfo=!,'100,<1000,s100,h virtualedit=all whichwrap=b,s,<,>,[,] wildmenu
set wildoptions= nowrap nowritebackup

" shell
if has('win32')
    let &shell = better#exepath('bash')
    if empty(&shell)
        set shell&
    else
        set shellcmdflag=-c shellredir=>%s\ 2>&1 shellslash noshelltemp shellxescape=
        let &shellxquote = has('nvim') ? '' : '"'
        let [$CYGWIN, $MSYS] ..= [' noglob', ' noglob']
    endif
endif

" keyboard and spelling
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
call better#defaults(#{gzip: 0, netrwPlugin: 0, spellfile_plugin: 0, tarPlugin: 0,
    \ tutor_mode_plugin: 0, zipPlugin: 0, 2html_plugin: 0}, 'loaded')
call better#defaults(has('nvim') ? #{node_provider: 0, perl_provider: 0,
    \ python_provider: 0, python3_provider: 0, ruby_provider: 0, remote_plugins: 0,
    \ shada_plugin: 0} : #{getscriptPlugin: 0, logiPat: 0, rrhelper: 0,
    \ vimballPlugin: 0}, 'loaded')

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
