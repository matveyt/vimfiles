" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if has('gui_running')
    set guifont=Inconsolata\ LGC:h14:cRUSSIAN
    set background=dark renderoptions=type:directx
    " this is in case the colors were set from a desktop shortcut
    if !exists('g:colors_name')
        silent! colorscheme hybrid
    endif
elseif &term =~# '256color'
    set background=dark termguicolors
    set ttyfast ttymouse=xterm2
    silent! colorscheme flattened_dark
else
    silent! colorscheme modest
endif
