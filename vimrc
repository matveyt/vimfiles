" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" setup critical defaults
set encoding=utf-8
if exists('+shellslash')
    set shellslash
endif

" enable filetype, indent and syntax
filetype plugin indent on
syntax on

" remember our root path
let g:dotvim = expand('<sfile>:h')

" source startup scripts
let s:rclist = sort(glob(g:dotvim..'/vimrc.d/*.vim', 1, 1))
if !empty(s:rclist) && !v:vim_did_enter
    " the last script is delayed until VimEnter
    execute 'autocmd VimEnter * ++once ++nested source' remove(s:rclist, -1)
endif
for s:item in s:rclist
    execute 'source' s:item
endfor
unlet! s:item s:rclist
