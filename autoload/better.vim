" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" better#bufwinid({expr})
" prefer current window ID;
" not confined to the current tab
function! better#bufwinid(buf) abort
    let l:bufnr = bufnr(a:buf)
    if l:bufnr == -1
        " invalid buffer
        return -1
    elseif l:bufnr == bufnr()
        " current buffer
        return win_getid()
    endif
    " find in the current tab
    let l:winid = bufwinid(l:bufnr)
    if l:winid == -1
        " find first match
        let l:winid = get(win_findbuf(l:bufnr), 0, -1)
    endif
    return l:winid
endfunction

" better#call({func}, {arglist})
" better#call({func}, {arg1} ...)
" safe function call
function! better#call(func, ...) abort
    let l:args = a:0 == 1 && type(a:1) == v:t_list ? a:1 : a:000
    try
        return call(a:func, l:args)
    catch
        return get(l:args, 0)
    endtry
endfunction

" better#defaults({dict} [, {base}])
" set default variables
function! better#defaults(dict, base = v:null) abort
    if empty(a:base)
        call extend(g:, a:dict, 'keep')
    else
        for [l:var, l:value] in items(a:dict)
            let l:name = a:base..'_'..l:var
            if !has_key(g:, l:name)
                let g:[l:name] = l:value
            endif
        endfor
    endif
endfunction

" better#gui_running()
" Vim/Neovim compatibility
function! better#gui_running() abort
    return has('gui_running') || exists('*nvim_list_uis') &&
        \ nvim_list_uis()->get(-1, {})->get('chan') > 0
endfunction

" better#is_blank_buffer([{buf}])
" check if buffer is blank
function! better#is_blank_buffer(buf = '') abort
    return a:buf->bufname()->empty() && a:buf->getbufvar('&buftype')->empty() &&
        \ a:buf->getbufvar('&modified') == 0
endfunction

" better#safe({what} [, {cond}])
" execute command or set option safely
function! better#safe(what, ...) abort
    if a:0
        let l:cond = a:1
    else
        let [l:str, _, l:end] = matchstrpos(a:what, '\a\+')
        if l:str is# 'set' || l:str =~# '^setl\%[ocal]$' || l:str =~# '^setg\%[lobal]$'
            let l:str = matchstr(a:what, '\a\+', l:end + 1)
            let l:cond = exists('+'..substitute(l:str, '^\C\%(inv\|no\)', '', ''))
        else
            let l:cond = exists(':'..l:str) == 2
        endif
    endif
    if l:cond
        execute a:what
    endif
endfunction

" better#stdpath({what}, [{subdir} ...])
" return full path to {subdir} under Vim/Neovim stdpath()
function! better#stdpath(what, ...) abort
    let l:path = exists('*stdpath') ? stdpath(a:what) : strpart(&pp, 0, stridx(&pp, ','))
    if a:0
        let l:path .= '/' . call('printf', a:000)
    endif
    if exists('+shellslash') && &shellslash
        let l:path = tr(l:path, '\', '/')
    endif
    return l:path
endfunction

" better#win_execute({id}, {command} [, {silent}])
" Vim/Neovim compatibility
function! better#win_execute(id, command, silent = 'silent') abort
    " call win_execute() if possible
    if a:id < 1000
        return ''
    elseif exists('*win_execute')
        return win_execute(a:id, a:command, a:silent)
    endif
    " try to switch active window
    let l:curr = win_getid()
    let l:goto = a:id != l:curr
    if l:goto
        noautocmd let l:goto = win_gotoid(a:id)
        if !l:goto
            return ''
        endif
    endif
    " execute command and switch window back after that
    try | return execute(a:command, a:silent)
    finally
        if l:goto
            noautocmd call win_gotoid(l:curr)
        endif
    endtry
endfunction
