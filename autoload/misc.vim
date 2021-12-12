" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" misc#bwipeout({listed})
" wipe all deleted (unloaded & unlisted) or all unloaded buffers
function! misc#bwipeout(listed = 0) abort
    let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded && (!v.listed || a:listed)})
    if !empty(l:buffers)
        execute 'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
    endif
endfunction

" misc#comment({line1}, {line2} [, {preserveindent}])
" (un)comment line range
function! misc#comment(line1, line2, pi = &preserveindent) abort
    let l:lnum = nextnonblank(a:line1)
    let l:end = type(a:line2) == v:t_number ? a:line2 : line(a:line2)
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
    setlocal bufhidden=wipe buftype=nofile noswapfile
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
function! misc#gcc_include(gcc = 'gcc', force = v:false, ft = &filetype) abort
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
    return s:[l:var]
endfunction

" misc#guifont({typeface}, {height})
" set &guifont
function! misc#guifont(typeface, height) abort
    let l:fonts = split(better#or(a:typeface, &guifont), ',')
    let l:height = (a:height >= 10) ? a:height : get(s:, 'fontheight', 10) + a:height
    let l:prefix = has('gui_gtk') ? ' ' : ':h'
    call map(l:fonts, {_, v -> substitute(trim(v), '\v('..l:prefix..'(\d+))?$',
        \ printf('\=%s..%d', string(l:prefix), l:height), '')})
    silent! let &guifont = join(l:fonts, ',')
    let s:fontheight = l:height
endfunction

" misc#pick({name} [, {cmd} [, {items} [, {items2lines}]]])
" pick parameter and execute {cmd}
function! misc#pick(...) abort
    let l:name  = get(a:, 1)->empty() ? 'help' : a:1
    let l:cmd   = get(a:, 2)->empty() ? '%{name} %{items[result - 1]}' : a:2
    let l:items = get(a:, 3)->empty() ? getcompletion(l:name..' ', 'cmdline') : a:3
    let l:lines = get(a:, 4)->empty() ? l:items : copy(l:items)->map(a:4)
    call popup#menu(l:lines, #{title: printf('[%s]', l:name), maxheight: &pumheight ?
        \ &pumheight : &lines / 2, minwidth: &pumwidth, callback: {id, result ->
        \ (result < 1 || result > len(items)) ? v:null :
        \ execute(substitute(l:cmd, '%{\([^}]\+\)}', '\=eval(submatch(1))', 'g'), '')}})
endfunction
