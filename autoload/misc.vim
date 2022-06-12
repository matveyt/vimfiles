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

" misc#comment({line1}, {line2} [, {preserveindent}])
" (un)comment line range
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

" misc#nomove({fmt} [, {expr1} ...])
" format and execute command without moving cursor
function! misc#nomove(...) abort
    let l:cmd = stridx(a:1, '%') < 0 ? join(a:000) : call('printf', a:000)
    let l:pos = winsaveview()
    try | return execute(l:cmd, '')
    finally
        call winrestview(l:pos)
    endtry
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
