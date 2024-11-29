" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" better#aug_remove({name} ...)
" remove augroups
function! better#aug_remove(...) abort
    for l:name in a:000
        if exists('#'..l:name)
            execute 'autocmd!' l:name
            execute 'augroup!' l:name
        endif
    endfor
endfunction

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

" better#bwipeout({expr})
" wipe buffers matching {expr}
function! better#bwipeout(expr) abort
    let l:buffers = getbufinfo()->filter(a:expr)
    if !empty(l:buffers)
        execute 'bwipeout' l:buffers->map('v:val.bufnr')->join()
    endif
endfunction

" better#call({func}, {arglist})
" better#call({func}, {arg1} ...)
" safe function call
function! better#call(func, ...) abort
    let l:args = (a:0 == 1 && type(a:1) == v:t_list) ? a:1 : a:000
    try | noautocmd return call(a:func, l:args)
    catch | return get(l:args, 0)
    endtry
endfunction

" better#comment({line1}, {line2} [, {pi}])
" toggle comments
function! better#comment(line1, line2, pi=&pi) abort
    let l:lnum = nextnonblank(a:line1)
    let l:end = prevnonblank(a:line2)
    if l:lnum >= 1 && l:lnum <= l:end
        let l:pat = printf('^\(\s*\)\(%s\)$', printf(escape(&cms, '^$.*~[]\'), '\(.*\)'))
        let l:sub = '\=empty(submatch(2)) ? submatch(0) : submatch(1)..submatch(3)'
        if getline(l:lnum) !~# l:pat
            let l:pat = a:pi ? '^\s*\zs.*' : '.*'
            let l:sub = printf(escape(&cms, '&\'), '&')
        endif
        call setline(l:lnum, map(getline(l:lnum, l:end), {_, v -> empty(v) ? v :
            \ substitute(v, l:pat, l:sub, '')}))
    endif
endfunction

" better#defaults({dict} [, {base}])
" set default variables
function! better#defaults(dict, base=v:null) abort
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

" better#diff([{spec}])
" improved :DiffOrig implementation
function! better#diff(spec='HEAD') abort
    execute matchstr(&diffopt, 'vertical') 'new'
    setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
    let &l:filetype = getbufvar(0, '&filetype')
    nnoremap <buffer>q <C-W>q
    execute 'silent file' a:spec ?? 'ORIG'
    execute 'silent read ++edit' empty(a:spec) ? '#' : printf('!git -C %s show %s:./%s',
        \ shellescape(expand('#:p:h'), 1), a:spec, shellescape(expand('#:t'), 1))
    1delete_
    diffthis
    wincmd p
    diffthis
endfunction

" better#encode({line1}, {line2} [, {oper}])
" C/URL encode/decode
let s:c_escape = {"\007": '\a', "\010": '\b', "\011": '\t', "\012": '\n', "\013": '\v',
    \ "\014": '\f', "\015": '\r', "\033": '\e', "\"": '\"', "'": '\''', '\': '\\'}
let s:c_unescape = {'a': "\007", 'b': "\010", 't': "\011", 'n': "\012", 'v': "\013",
    \ 'f': "\014", 'r': "\015", 'e': "\033"}
function! better#encode(line1, line2, oper) range abort
    if a:oper is? 'URL'
        let l:Func = {_, v ->
            \ substitute(iconv(v, 'latin1', 'utf-8'), '[^-[:alnum:]_.~:/?#@]',
            \ '\=printf("%%%02X", char2nr(submatch(0), 1))', 'g')}
    elseif a:oper is? 'URL!'
        let l:Func = {_, v ->
            \ iconv(substitute(tr(v, '+', ' '), '%\(\x\x\)',
            \ '\=nr2char(str2nr(submatch(1), 16), 1)', 'g'), 'utf-8', 'latin1')}
    elseif a:oper is? 'C!'
        let l:Func = {_, v -> substitute(v,
            \ '\v\\(\o{1,3}|x\x{1,2}|u\x{4}|\U\x{8}|.)',
            \ '\=has_key(s:c_unescape, submatch(1)) ? s:c_unescape[submatch(1)] : ' .
            \ 'submatch(1) =~# "^[0-7xuU]" ? eval("\"\\"..submatch(1).."\"") : ' .
            \ 'submatch(1)', 'g')}
    else "if a:oper is? 'C'
        let l:last = a:line2 - a:line1
        let l:Func = {k, v -> substitute(v,
            \ "[\001-\033\\\\\"']", '\=has_key(s:c_escape, submatch(0)) ? ' .
            \ 's:c_escape[submatch(0)] : printf("\\%03o", char2nr(submatch(0)))', 'g') .
            \ repeat('\n\', k < l:last)}
    endif

    call setline(a:line1, getline(a:line1, a:line2)->map(l:Func))
endfunction

" better#gcc_include([{gcc} [, {ft} [, {force}]]])
" get GCC include dirs
function! better#gcc_include(gcc=b:current_compiler, ft=&ft, force=v:false) abort
    let l:var = printf('%s_include_%s', fnamemodify(a:gcc, ':t:gs?[-.]?_?'), a:ft)
    if a:force || !has_key(s:, l:var)
        " $CPATH
        let s:[l:var] = split($CPATH, has('win32') ? ';' : ':')
        " builtin dirs
        let l:cmd = printf('%s -x%s -v -E -', a:gcc, a:ft is# 'cpp' ? 'c++' : a:ft)
        let l:include = map(systemlist(l:cmd, []), 'trim(v:val)')
        let l:ix1 = match(l:include, '#include <\.\.\.>') + 1
        let l:ix2 = match(l:include, '\.$', l:ix1) - 1
        if l:ix1 <= l:ix2
            let s:[l:var] += map(l:include[l:ix1 : l:ix2], 'simplify(v:val)')
        endif
    endif
    return copy(s:[l:var])
endfunction

" better#guifont({typeface} [, {height}])
" set &guifont
function! better#guifont(typeface, height=0) abort
    let l:fonts = split(a:typeface ?? &guifont, ',')
    let l:prefix = has('gui_gtk') ? ' ' : ':h'
    let s:fontheight = (a:height >= 10) ? a:height : get(s:, 'fontheight', 10) + a:height
    call map(l:fonts, {_, v -> substitute(trim(v), '\v('..l:prefix..'(\d+))?$',
        \ printf('\=%s..%d', string(l:prefix), s:fontheight), '')})
    silent! let &guifont = join(l:fonts, ',')
endfunction

" better#gui_running()
" Vim/Neovim compatibility
function! better#gui_running() abort
    return has('gui_running') || exists('*nvim_list_uis') &&
        \ nvim_list_uis()->get(-1, {})->get('chan') > 0
endfunction

" better#is_blank_buffer([{buf}])
" check if buffer is blank
function! better#is_blank_buffer(buf='') abort
    return a:buf->bufname()->empty() && a:buf->getbufvar('&buftype')->empty() &&
        \ a:buf->getbufvar('&modified') == 0
endfunction

" better#nextfile([{offset} [, {file}]])
" find next file in the same directory with respect to 'wildignore'
function! better#nextfile(offset=1, file=expand('%:p')) abort
    let l:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
    let l:path = fnamemodify(a:file, ':h')..l:slash
    let l:name = filter(getcompletion(l:path, 'file', 1), {_, v -> v[-1:] !=# l:slash})
    return empty(l:name) ? '' : l:name[(index(l:name, a:file) + a:offset) % len(l:name)]
endfunction

" better#nomove({cmd})
" execute command while keeping cursor in place
function! better#nomove(cmd) abort
    defer winrestview(winsaveview())
    return execute(a:cmd, '')
endfunction

" better#once({func} [, {sid} [, ...]])
" call function once
function! better#once(name, sid=expand('<SID>'), ...) abort
    let s:called = get(s:, 'called', {})
    let l:func = a:sid..a:name
    if !has_key(s:called, l:func)
        let s:called[l:func] = v:true
        return better#call(l:func, a:000)
    endif
endfunction

" better#pick({name} [, {cmd} [, {items} [, {items2lines}]]])
" pick parameter and execute {cmd}
function! better#pick(...) abort
    let l:name  = get(a:, 1, v:null) isnot v:null ? a:1 : 'help'
    let l:cmd   = get(a:, 2, v:null) isnot v:null ? a:2 : '{name} {items[result - 1]}'
    let l:items = get(a:, 3, v:null) isnot v:null ? a:3 :
        \ getcompletion(l:name..' ', 'cmdline')
    let l:lines = get(a:, 4, v:null) isnot v:null ? copy(l:items)->map(a:4) : l:items
    call popup#menu(l:lines, #{title: l:name->printf('[%s]'), maxheight: &pumheight ?
        \ &pumheight : &lines / 2, minwidth: &pumwidth, callback: {id, result ->
        \ (result < 1 || result > len(items)) ? v:null :
        \ l:cmd->substitute('{\([^}]\+\)}', '\=eval(submatch(1))', 'g')->execute('')}})
endfunction

" better#put({how} [, {reg} [, {count}]])
" put register linewise
function! better#put(how, reg=v:register, count=v:count1) abort
    defer setreg(a:reg, '', 'a'..getregtype(a:reg))
    call setreg(a:reg, '', 'aV')
    execute printf('normal! "%s%d%s', a:reg, a:count, a:how)
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
function! better#win_execute(id, command, silent='silent') abort
    " call win_execute() if possible
    if a:id < 1000
        return ''
    elseif exists('*win_execute')
        return win_execute(a:id, a:command, a:silent)
    endif
    " try to switch active window
    let l:curr = win_getid()
    if a:id != l:curr
        defer better#call('win_gotoid', l:curr)
        call better#call('win_gotoid', a:id)
    endif
    " execute command and switch window back after that
    return execute(a:command, a:silent)
endfunction
