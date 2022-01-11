" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

runtime! vimrc.d/*.vim

if !exists("did_load_filetypes") && !has("nvim")
    filetype plugin indent on
    syntax enable
endif
