" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" extra directories
call mkdir(better#stdpath('data', 'site/sessions'), 'p', 0700)
call mkdir(better#stdpath('data', 'site/templates'), 'p', 0700)

if !exists("did_load_filetypes") && !has("nvim")
    let did_install_syntax_menu = 1
    filetype plugin indent on
    syntax on
    unlet did_install_syntax_menu
endif

runtime! vimrc.d/*.vim
