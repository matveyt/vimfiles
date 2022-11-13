" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" misc#bwipeout({expr})
" wipe some buffers
function! misc#bwipeout(expr) abort
    let l:buffers = getbufinfo()->filter(a:expr)
    if !empty(l:buffers)
        execute 'bwipeout' l:buffers->map('v:val.bufnr')->join()
    endif
endfunction

" misc#comment({line1}, {line2} [, {pi}])
" toggle comments
function! misc#comment(line1, line2, pi = &preserveindent) abort
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

" misc#diff([{org} [, {spec}]])
" improved implementation of :DiffOrig
function! misc#diff(org = v:false, ...) abort
    let l:org = a:org || &modified && !a:0
    let l:spec = get(a:, 1, 'HEAD')
    execute matchstr(&diffopt, 'vertical') 'new'
    setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
    let &l:filetype = getbufvar(0, '&filetype')
    nnoremap <buffer>q <C-W>q
    execute 'silent file' l:org ? 'ORG' : l:spec
    execute 'silent read ++edit' l:org ? '#' : printf('!git -C %s show %s:./%s',
        \ shellescape(expand('#:p:h'), 1), l:spec, shellescape(expand('#:t'), 1))
    1delete_
    diffthis
    wincmd p
    diffthis
endfunction

" misc#encode({line1}, {line2} [, {oper}])
" C/URL encode/decode
let s:c_escape = {"\007": '\a', "\010": '\b', "\011": '\t', "\012": '\n', "\013": '\v',
    \ "\014": '\f', "\015": '\r', "\033": '\e', "\"": '\"', "'": '\''', '\': '\\'}
let s:c_unescape = {'a': "\007", 'b': "\010", 't': "\011", 'n': "\012", 'v': "\013",
    \ 'f': "\014", 'r': "\015", 'e': "\033"}
function! misc#encode(line1, line2, oper) range abort
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

" misc#gcc_include([{gcc} [, {force} [, {ft}]]])
" get GCC include dirs
function! misc#gcc_include(gcc = b:current_compiler, force = v:false, ft = &ft) abort
    let l:var = printf('%s_include_%s', fnamemodify(a:gcc, ':t:gs?[-.]?_?'), a:ft)
    if a:force || !has_key(s:, l:var)
        " $INCLUDE
        let s:[l:var] = split($INCLUDE, has('win32') ? ';' : ':')
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

" misc#guifont({typeface} [, {height}])
" set &guifont
function! misc#guifont(typeface, height = 0) abort
    let l:fonts = split(better#or(a:typeface, &guifont), ',')
    let l:prefix = has('gui_gtk') ? ' ' : ':h'
    let s:fontheight = a:height >= 10 ? a:height : get(s:, 'fontheight', 10) + a:height
    call map(l:fonts, {_, v -> substitute(trim(v), '\v('..l:prefix..'(\d+))?$',
        \ printf('\=%s..%d', string(l:prefix), s:fontheight), '')})
    silent! let &guifont = join(l:fonts, ',')
endfunction

" misc#nextfile([{file} [, {offset}]])
" find next file in the same directory with respect to 'wildignore'
function! misc#nextfile(file = expand('%:p'), offset = 1) abort
    let l:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
    let l:path = fnamemodify(a:file, ':h')..l:slash
    let l:name = filter(getcompletion(l:path, 'file', 1), {_, v -> v[-1:] !=# l:slash})
    return empty(l:name) ? '' : l:name[(index(l:name, a:file) + a:offset) % len(l:name)]
endfunction

" misc#nomove({fmt}, {expr1} ...)
" format and execute command without moving cursor
function! misc#nomove(...) abort
    let l:cmd = stridx(a:1, '%') < 0 ? join(a:000) : call('printf', a:000)
    let l:pos = winsaveview()
    try | return execute(l:cmd, '')
    finally
        call winrestview(l:pos)
    endtry
endfunction

" misc#once({func} [, {sid} [, ...]])
" call function once
function! misc#once(name, sid = expand('<SID>'), ...) abort
    let s:called = get(s:, 'called', {})
    let l:func = empty(a:sid) ? a:name : a:sid..a:name
    if !has_key(s:called, l:func)
        let s:called[l:func] = v:true
        return better#call(l:func, a:000)
    endif
endfunction

" misc#pick({name} [, {cmd} [, {items} [, {items2lines}]]])
" pick parameter and execute {cmd}
function! misc#pick(...) abort
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

" misc#put({how} [, {reg} [, {count}]])
" put register linewise
function! misc#put(how, reg = v:register, count = v:count1) abort
    let l:type = getregtype(a:reg)
    if l:type isnot# 'V'
        let l:value = getreg(a:reg)
        call setreg(a:reg, l:value, 'V')
    endif
    execute printf('normal! "%s%d%s', a:reg, a:count, a:how)
    if l:type isnot# 'V'
        call setreg(a:reg, l:value, l:type)
    endif
endfunction
