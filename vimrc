" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" setup defaults
set encoding=utf-8
scriptencoding utf-8
" before 'defaults.vim' to make vimtex happy
filetype plugin indent on
" source Vim's default settings (no-op in Neovim)
runtime defaults.vim

" local paths
if has('unix')
    let g:my_dotvim = '~/.vim'
    let g:my_misc = '/e/Misc'
    let g:my_projects = '/e/Work/projects'
else
    let g:my_dotvim = 'E:/msys64/home/' . $USERNAME . '/.vim'
    let g:my_misc = 'E:/Misc'
    let g:my_projects = 'E:/Work/projects'
endif

" g:GuiLoaded is set in Neovim (by a plugin); set it for gVim too
if has('gui_running')
    let g:GuiLoaded = 1
endif

" Logical and/or: returns first empty/non-empty argument or the last one
function s:junction(test, ...)
    let l:arg = 0
    for l:arg in a:000
        if empty(l:arg) != a:test
            break
        endif
    endfor
    return l:arg
endfunction
let And = funcref('s:junction', [0])
let Or = funcref('s:junction', [1])

" source startup scripts
for s:fname in sort(glob(g:my_dotvim . '/vimrc.d/*.vim', 0, 1))
    execute 'source' s:fname
endfor
unlet s:fname
