" This is a part of my Vim configuration
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

" better#bwipeout({expr})
" wipe buffers matching {expr}
function! better#bwipeout(expr) abort
    let l:buffers = getbufinfo()->filter(a:expr)
    if !empty(l:buffers)
        execute 'bwipeout' join(map(l:buffers, 'v:val.bufnr'))
    endif
endfunction

" better#call({func}, {arglist})
" better#call({func}, {arg1} ...)
" safe function call
function! better#call(func, ...) abort
    let l:args = (get(a:, 1)->type() is v:t_list) ? a:1 : a:000
    try | noautocmd return call(a:func, l:args)
    catch | return get(l:args, 0)
    endtry
endfunction

" better#comment({line1}, {line2} [, {pi}])
" toggle comments
function! better#comment(line1, line2, pi=&pi) abort
    let [l:lnum, l:end] = [nextnonblank(a:line1), prevnonblank(a:line2)]
    if l:lnum >= 1 && l:lnum <= l:end
        let l:pat = printf('^\(\s*\)\(%s\)$', printf(escape(&cms, '^$.*~[]\'), '\(.*\)'))
        let l:sub = '\=empty(submatch(2)) ? submatch(0) : submatch(1)..submatch(3)'
        if getline(l:lnum) !~# l:pat
            let l:pat = a:pi ? '^\s*\zs.*' : '.*'
            let l:sub = printf(escape(&cms, '&\'), '&')
        endif
        call getline(l:lnum, l:end)->map({_, v -> substitute(v, l:pat, l:sub, '')})
            \ ->setline(l:lnum)
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
    execute 'silent read ++edit' empty(a:spec) ? '#' : printf('!%s -C %s show %s:./%s',
        \ better#exepath('git'), shellescape(expand('#:p:h'), 1), a:spec,
        \ shellescape(expand('#:t'), 1))
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

    return getline(a:line1, a:line2)->map(l:Func)->setline(a:line1)
endfunction

" better#exepath({tool})
" preset/cached exepath()
function! better#exepath(tool) abort
    if !exists('g:exepath_{a:tool}')
        let g:exepath_{a:tool} = exepath(a:tool)->tr('\', '/')
    endif
    return g:exepath_{a:tool}
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
" build &guifont from params
function! better#guifont(typeface, height=0) abort
    let l:fonts = split(a:typeface ?? &guifont, ',')
    let l:prefix = has('gui_gtk') ? ' ' : ':h'
    let s:font_height = (a:height < 10) ? get(s:, 'font_height', 10) + a:height :
        \ a:height
    call map(l:fonts, {_, v -> substitute(trim(v), '\v('..l:prefix..'(\d+))?$',
        \ printf('\=%s..%d', string(l:prefix), s:font_height), '')})
    return join(l:fonts, ',')
endfunction

" better#gui_running()
" Vim/Neovim compatibility
function! better#gui_running() abort
    return has('gui_running') || exists('*nvim_list_uis') &&
        \ nvim_list_uis()->get(-1, {})->get('chan') > 0
endfunction

" better#is_blank_buffer([{buf}])
" check if buffer is blank
function! better#is_blank_buffer(buf='%') abort
    return a:buf->bufname()->empty() && a:buf->getbufvar('&buftype')->empty() &&
        \ a:buf->getbufvar('&modified') == 0
endfunction

" better#nextfile([{offset} [, {file}]])
" find next file in the same directory with respect to &wildignore
function! better#nextfile(offset=1, file=expand('%:p')) abort
    let l:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
    let l:path = fnamemodify(a:file, ':h')..l:slash
    let l:name = filter(getcompletion(l:path, 'file', 1), {_, v -> v[-1:] !=# l:slash})
    return empty(l:name) ? '' : l:name[(index(l:name, a:file) + a:offset) % len(l:name)]
endfunction

" better#nomove({cmd} [, {silent}])
" execute command while keeping cursor in place
function! better#nomove(cmd, silent='') abort
    defer winrestview(winsaveview())
    return execute(a:cmd, a:silent)
endfunction

" better#once({func} [, {sid} [, ...]])
" call function once
function! better#once(name, sid=expand('<SID>'), ...) abort
    let s:called = get(s:, 'called', {})
    let l:name = a:sid..a:name
    if !has_key(s:called, l:name)
        let s:called[l:name] = v:true
        return better#call(l:name, a:000)
    endif
endfunction

" better#putreg({type} [, {oper} [, {reg} [, {count}]]])
" put register with type overridden
function! better#putreg(type, oper='p', reg=v:register, count=v:count1) abort
    let l:info = getreginfo(a:reg)
    let l:reg = get(l:info, 'points_to', a:reg)
    if l:info.regtype isnot# a:type
        defer setreg(l:reg, '', 'a'..l:info.regtype)
        call setreg(l:reg, '', 'a'..a:type)
    endif
    execute 'normal! "'..l:reg..a:count..a:oper
endfunction

" better#safe({what})
" execute command or set option safely
function! better#safe(what) abort
    let [l:str, _, l:end] = matchstrpos(a:what, '\a\+')
    if l:str is# 'set' || l:str =~# '^setl\%[ocal]$' || l:str =~# '^setg\%[lobal]$'
        " set option
        if exists('+'..substitute(matchstr(a:what, '\a\+', l:end + 1),
            \ '^\C\%(inv\|no\)', '', ''))
            execute a:what
        endif
    elseif exists(':'..l:str) == 2
        " execute command
        execute a:what
    endif
endfunction

" better#stdpath({what}, [{subdir} ...])
" return full path to {subdir} under Vim/Neovim stdpath()
function! better#stdpath(what, ...) abort
    if exists('*stdpath')
        let l:path = stdpath(a:what)
    else
        if !exists('s:stdpath')
            let l:packpath = split(&packpath, ',')
            let l:directory = split(&directory, ',')
            let s:stdpath = {}
            let s:stdpath.config = l:packpath[0]
            let s:stdpath.data = s:stdpath.config
            let s:stdpath.config_dirs = l:packpath[1:]
            let s:stdpath.data_dirs = []
            let s:stdpath.cache = tempname()->fnamemodify(':h')
            let s:stdpath.run = s:stdpath.cache
            let s:stdpath.state = get(l:directory, 1, s:stdpath.cache)
            let s:stdpath.log = s:stdpath.state
        endif
        let l:path = get(s:stdpath, a:what, '.')
    endif
    if type(l:path) is v:t_string
        if a:0
            let l:path ..= '/'..call('printf', a:000)
        endif
        if &shellslash
            let l:path = tr(l:path, '\', '/')
        endif
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
