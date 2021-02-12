" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if !exists("did_load_filetypes") && !has("nvim")
    let did_install_syntax_menu = 1
    filetype plugin indent on
    syntax on
    unlet did_install_syntax_menu
endif

runtime! vimrc.d/*.vim
