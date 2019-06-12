" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" setup defaults
set encoding=utf-8
scriptencoding utf-8
if has('win32unix')
    " ensure LANG is set for msys/vim
    language ru_RU.UTF-8
endif
runtime defaults.vim

" local paths
if has('unix')
    let g:my_dotvim = '~/.vim'
    let g:my_projects = '/e/Work/projects'
else
    let g:my_dotvim = 'E:/msys64/home/' . $USERNAME . '/.vim'
    let g:my_projects = 'E:/Work/projects'
endif

" source startup scripts
for s:fname in sort(glob(g:my_dotvim . '/vimrc.d/*.vim', 0, 1))
    execute 'source' s:fname
endfor

" autoload'ed stuff
let &statusline = statusline#get()
nnoremap <F8> :<C-U>call colorswitcher#next(v:count1)<CR>
nnoremap <S-F8> :<C-U>call colorswitcher#next(-v:count1)<CR>
