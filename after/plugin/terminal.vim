" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if exists('g:GuiLoaded')
    if has('nvim')
        call GuiWindowMaximized(1)
    endif
    set guifont=Inconsolata\ LGC:h14:cRUSSIAN
    if has('directx')
        set renderoptions=type:directx
    endif
    " in case the colors were set by a desktop shortcut
    if !exists('g:colors_name')
        set background=dark
        silent! colorscheme hybrid
    endif
elseif &t_Co >= 256
    " assume we also have TrueColor support
    set termguicolors
    if !has('nvim')
        set ttyfast ttymouse=xterm2
    endif
    silent! colorscheme flattened_dark
else
    silent! colorscheme modest
endif

" set some nice icons for vim-dirvish to use
if exists('g:loaded_dirvish') && !has('nvim')
    " Neovim-qt cannot display Unicode SMP characters for some reason
    call dirvish#add_icon_fn({p -> exists('g:GuiLoaded') ?
        \ nr2char(p[-1:] == '/' ? 0x1F4C2 : 0x1F4C4, 1) : ''})
endif
