" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

runtime! vimrc.d/*.vim

if !has('nvim') && !exists('did_load_filetypes')
    filetype plugin indent on
    syntax enable
endif
