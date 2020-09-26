" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" save config dir
set shellslash
let g:dotvim = expand('<sfile>:h')

" do :runtime! vimrc.d/*.vim
" Note: glob() is always sorted
let s:rclist = glob(g:dotvim..'/vimrc.d/*.vim', 0, 1)
if !empty(s:rclist) && !v:vim_did_enter
    " the last script is delayed until VimEnter
    execute 'autocmd VimEnter * ++once ++nested source'
        \ fnameescape(remove(s:rclist, -1))
endif
for s:item in s:rclist
    source `=s:item`
endfor
unlet! s:item s:rclist
