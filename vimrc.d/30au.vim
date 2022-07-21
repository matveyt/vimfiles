" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

augroup vimStartup | au!
    " :h restore-cursor
    autocmd BufRead * call getpos("'\"")->setpos('.')
    " 'q' to close special windows/buffers (e.g. 'help')
    autocmd BufWinEnter *
        \   if !empty(&buftype)
        \ |     execute 'nnoremap <buffer>q <C-W>c'
        \ | endif
    " update timestamp before saving buffer
    autocmd BufWrite *
        \   if &modified && &modeline && &modelines > 0
        \ |     let s:lc_time = v:lc_time
        \ |     language time C
        \ |     call misc#nomove('
        \               silent! undojoin
        \           |   keepj keepp 1,%ds/\v\C%s\s*\zs.*/%s/e',
        \           min([&modelines, line('$')]), '%(Last Change|Date):',
        \           strftime('%Y %b %d'))
        \ |     execute 'language time' remove(s:, 'lc_time')
        \ | endif
    " never italicize comments
    autocmd ColorScheme * hi Comment gui=NONE
    " prettify some buffers
    autocmd FileType man,qf setlocal colorcolumn& cursorline& list&
    " save session on exit
    autocmd VimLeavePre *
        \   if !v:dying
        \ |     call misc#bwipeout('v:val.bufnr->getbufvar("&ft") =~# "^git"')
        \ |     if !empty(v:this_session)
        \ |         mksession! `=v:this_session`
        \ |     endif
        \ | endif
augroup end
