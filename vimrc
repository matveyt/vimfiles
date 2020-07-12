" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" setup missing defaults for Vim
if !has('nvim')
    set encoding=utf-8
    filetype plugin indent on
    syntax on
endif

" remember our root path
if exists('+shellslash')
    set shellslash
endif
let g:dotvim = expand('<sfile>:h')

" source startup scripts
let s:rclist = sort(glob(g:dotvim..'/vimrc.d/*.vim', v:true, v:true))
if !empty(s:rclist) && !v:vim_did_enter
    " the last script is delayed until VimEnter
    execute 'autocmd VimEnter * ++once ++nested source' remove(s:rclist, -1)
endif
for s:item in s:rclist
    source `=s:item`
endfor
unlet! s:item s:rclist
