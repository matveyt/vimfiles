" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" setup defaults
set encoding=utf-8
if exists('+shellslash')
    set shellslash
endif
runtime defaults.vim

" remember our root path
let g:dotvim = expand('<sfile>:h')
if has('win32') && !has('nvim')
    " resolve symlink
    let g:dotvim = tr(resolve(g:dotvim), '\', '/')
    " fix &runtimepath...
    let &rtp = expand('$VIMRUNTIME')
    for s:item in [expand('$VIM/vimfiles'), g:dotvim]
        let &rtp = printf('%s,%s,%s/after', s:item, &rtp, s:item)
    endfor
    " ...and &packpath
    if exists('+packpath')
        let &pp = &rtp
    endif
endif

" source startup scripts
let s:rclist = sort(glob(g:dotvim . '/vimrc.d/*.vim', 1, 1))
if !empty(s:rclist) && !v:vim_did_enter
    " the last script is delayed until VimEnter
    execute 'autocmd VimEnter * ++once ++nested source' remove(s:rclist, -1)
endif
for s:item in s:rclist
    execute 'source' s:item
endfor
unlet! s:item s:rclist
