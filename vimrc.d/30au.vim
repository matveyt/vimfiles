" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

augroup vimStartup | au!
    " :h restore-cursor
    autocmd BufRead * call setpos('.', getpos("'\""))
    " 'q' to close special windows/buffers (e.g. 'help')
    autocmd BufWinEnter *
        \   if !empty(&buftype)
        \ |     execute 'nnoremap <buffer>q <C-W>c'
        \ | endif
    " update timestamp before saving buffer
    autocmd BufWrite *
        \   if &modified && &modeline && &modelines > 0
        \ |     call misc#nomove(
        \           'silent! undojoin | keepj keepp 1,%ds/\v\C%s\s*\zs.*/%s/e',
        \           min([&modelines, line('$')]), '%(Last Change|Date):',
        \           strftime('%Y %b %d'))
        \ | endif
    " never italicize comments
    autocmd ColorScheme * hi Comment gui=NONE
    " prettify some buffers
    autocmd FileType man,qf setlocal colorcolumn& cursorline& list&
    " :h spell-SpellFileMissing
    autocmd SpellFileMissing * execute '!curl -OO --create-dirs --output-dir'
        \   shellescape(better#stdpath('config', 'spell'), v:true)
        \   shellescape(printf('%s/%s.%s.{spl,sug}',
        \       get(g:, 'spellfile_URL', 'https://ftp.nluug.nl/pub/vim/runtime/spell'),
        \       expand('<amatch>'), &encoding), v:true)
    " save session on exit
    autocmd VimLeavePre *
        \   if !v:dying
        \ |     call misc#bwipeout('v:val.bufnr->getbufvar("&bt") ==# "quickfix"')
        \ |     call misc#bwipeout('v:val.bufnr->getbufvar("&ft") =~# "commit$"')
        \ |     if !empty(v:this_session)
        \ |         mksession! `=v:this_session`
        \ |     endif
        \ | endif
augroup end
