" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

runtime! vimrc.d/*.vim

if !has("nvim")
    call better#safe("filetype plugin on", !exists("#filetypeplugin#FileType"))
    call better#safe("filetype indent on", !exists("#filetypeindent#FileType"))
    call better#safe("syntax enable", !exists("#syntaxset#FileType"))
endif
