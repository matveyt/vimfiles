" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

" term_start() compatibility wrapper
function! term#start(cmd=v:null, opts={}) abort
    let l:cmd = empty(a:cmd) ? [&shell] : a:cmd
    if exists('*term_start')
        return term_start(l:cmd, a:opts)
    elseif exists('*termopen')
        execute get(a:opts, 'curwin') ? 'enew' : get(a:opts, 'vertical') ? 'vnew' : 'new'
        call termopen(l:cmd, a:opts)
        execute 'resize' get(a:opts, 'term_rows', '+0')
        execute 'vertical resize' get(a:opts, 'term_cols', '+0')
        startinsert
        return bufnr()
    endif
endfunction

" Check if buffer indeed is running a terminal process
function! term#running(buf) abort
    return getbufvar(a:buf, '&buftype') isnot# 'terminal' ? 0 :
        \ has('terminal') ? term_getstatus(a:buf) =~# 'running' :
        \ has('nvim') ? jobwait([getbufvar(a:buf, '&channel')], 0)[0] == -1 :
        \ 0
endfunction

" term_sendkeys() compatibility wrapper
function! term#sendkeys(buf, keys) abort
    " make sure it's running a terminal process
    if !term#running(a:buf)
        return
    endif
    " accept List too
    let l:keys = (type(a:keys) == v:t_list) ? join(a:keys, "\r").."\r" : a:keys

    if exists('*chansend')
        " Neovim has chansend()
        call chansend(getbufvar(a:buf, '&channel'), l:keys)
    elseif exists('*term_sendkeys')
        " Vim has term_sendkeys()
        call term_sendkeys(a:buf, l:keys)
    else
        " try to put it directly (works in Neovim only?)
        call win_execute(bufwinid(a:buf), "put ="..string(l:keys)->tr("\n", "\r")
            \ ->escape('|"')
    endif

    " scrolling comes in handy for Terminal-Normal mode
    call win_execute(bufwinid(a:buf), [
        \ 'if line("$") > line("w$")',
        \   'normal! 999999z-',
        \ 'endif',
        \ ])
endfunction
