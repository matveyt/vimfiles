" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" emulation of tpope/vim-unimpaired plugin

" s:nextfile({off})
" find next file in current file directory
function s:nextfile(off) abort
    let l:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
    let l:curr = fnamemodify(@%, ':p')
    let l:path = fnamemodify(l:curr, ':h')..l:slash
    let l:file = filter(getcompletion(l:path, 'file', 1), {_, v -> v[-1:] !=# l:slash})
    return empty(l:file) ? '' :
        \ fnamemodify(l:file[(index(l:file, l:curr) + a:off) % len(l:file)], ':.')
endfunction

" s:nextprev({letter}, {prefix})
" create mappings to execute :next/:previous kind of commands
function s:nextprev(letter, prefix) abort
    execute printf("nnoremap <silent>[%s :%sfirst<CR>", toupper(a:letter), a:prefix)
    execute printf("nnoremap <silent>]%s :%slast<CR>", toupper(a:letter), a:prefix)
    execute 'nnoremap <expr><silent>['..a:letter
        \ 'printf(":<C-U>%d'..a:prefix..'previous<CR>", v:count1)'
    execute 'nnoremap <expr><silent>]'..a:letter
        \ 'printf(":<C-U>%d'..a:prefix..'next<CR>", v:count1)'
    if exists(':'..a:prefix..'pfile') == 2
        execute 'nnoremap <expr><silent>[<C-'..a:letter..'>'
            \ 'printf(":<C-U>%d'..a:prefix..'pfile<CR>", v:count1)'
        execute 'nnoremap <expr><silent>]<C-'..a:letter..'>'
            \ 'printf(":<C-U>%d'..a:prefix..'nfile<CR>", v:count1)'
    elseif exists(':p'..a:prefix..'previous') == 2
        execute 'nnoremap <expr><silent>[<C-'..a:letter..'>'
            \ 'printf(":<C-U>%dp'..a:prefix..'previous<CR>", v:count1)'
        execute 'nnoremap <expr><silent>]<C-'..a:letter..'>'
            \ 'printf(":<C-U>%dp'..a:prefix..'next<CR>", v:count1)'
    endif
endfunction

" s:putreg({how} [, {flip}])
" put v:register linewise or flip
function s:putreg(how, flip = v:false) abort
    let l:cmd = printf('normal! "%s%d%s', v:register, v:count1, a:how)
    let l:type = getregtype()
    if l:type is# 'V' && !a:flip
        " put as is
        execute l:cmd
        return
    endif

    let [l:reg, l:value] = [v:register, getreg()]
    if l:type is# 'V'
        " flip to charwise
        call setreg(l:reg, trim(l:value), 'v')
    else
        " force linewise
        call setreg(l:reg, l:value, 'V')
    endif
    try | execute l:cmd
    finally | call setreg(l:reg, l:value, l:type)
    endtry
endfunction

" s:toggle({letter}, {option} [, {value1}, {value2}])
" create mappings to toggle {option} value
function s:toggle(letter, option, ...) abort
    if eval('&'..a:option)->type() is v:t_string
        " string option with {value1} or {value2}
        execute printf('nnoremap <silent>[o%s :setl %s=%s<CR>', a:letter, a:option, a:1)
        execute printf('nnoremap <silent>]o%s :setl %s=%s<CR>', a:letter, a:option, a:2)
        execute printf('nnoremap <silent>yo%s :let &l:%s = (&l:%s is# %s) ? %s : %s<CR>',
            \ a:letter, a:option, a:option, string(a:1), string(a:2), string(a:1))
    elseif a:0
        " boolean option executing command {value1} or {value2}
        execute printf('nnoremap <silent>[o%s :%s<CR>', a:letter, a:1)
        execute printf('nnoremap <silent>]o%s :%s<CR>', a:letter, a:2)
        execute 'nnoremap <expr><silent>yo'..a:letter
            \ 'printf(":%s<CR>", &l:'..a:option '?' string(a:2) ':' string(a:1)..')'
    else
        " simple boolean option
        execute printf('nnoremap <silent>[o%s :setl %s<CR>', a:letter, a:option)
        execute printf('nnoremap <silent>]o%s :setl no%s<CR>', a:letter, a:option)
        execute printf('nnoremap <silent>yo%s :setl inv%s<CR>', a:letter, a:option)
    endif
endfunction

" URL encode/decode
function s:url_encode() range abort
    call setline(a:firstline, map(getline(a:firstline, a:lastline), {_, v ->
        \ substitute(iconv(v, 'latin1', 'utf8'), '[^-[:alnum:]_.~:/?#@]',
        \ '\=printf("%%%02X", char2nr(submatch(0), 1))', 'g')}))
endfunction
function s:url_decode() range abort
    call setline(a:firstline, map(getline(a:firstline, a:lastline), {_, v ->
        \ iconv(substitute(tr(v, '+', ' '), '%\(\x\x\)',
        \ '\=nr2char(str2nr(submatch(1), 16), 1)', 'g'), 'utf-8', 'latin1')}))
endfunction

" C string encode/decode
const s:escape = {"\007": '\a', "\010": '\b', "\011": '\t', "\012": '\n', "\013": '\v',
    \ "\014": '\f', "\015": '\r', "\033": '\e', "\"": '\"', "'": '\''', '\': '\\'}
const s:unescape = {'a': "\007", 'b': "\010", 't': "\011", 'n': "\012", 'v': "\013",
    \ 'f': "\014", 'r': "\015", 'e': "\033"}
function s:c_encode() range abort
    let l:last = a:lastline - a:firstline
    call setline(a:firstline, map(getline(a:firstline, a:lastline), {k, v ->
        \ substitute(v, "[\001-\033\\\\\"']", '\=has_key(s:escape, submatch(0)) ? ' .
        \ 's:escape[submatch(0)] : printf("\\%03o", char2nr(submatch(0)))', 'g') .
        \ repeat('\n\', k < l:last)}))
endfunction
function s:c_decode() range abort
    call setline(a:firstline, map(getline(a:firstline, a:lastline), {_, v ->
        \ substitute(v, '\v\\(\o{1,3}|x\x{1,2}|u\x{4}|\U\x{8}|.)',
        \ '\=has_key(s:unescape, submatch(1)) ? s:unescape[submatch(1)] : ' .
        \ 'submatch(1) =~# "^[0-7xuU]" ? eval("\"\\"..submatch(1).."\"") : ' .
        \ 'submatch(1)', 'g')}))
endfunction

" unimpaired-next
call s:nextprev('a', '')
call s:nextprev('b', 'b')
call s:nextprev('l', 'l')
call s:nextprev('q', 'c')
call s:nextprev('t', 't')

" [f ]f [n ]n
nnoremap <silent>[f :<C-U>edit <C-R>=fnameescape(<SID>nextfile(-v:count1))<CR><CR>
nnoremap <silent>]f :<C-U>edit <C-R>=fnameescape(<SID>nextfile(v:count1))<CR><CR>
noremap <expr>[n search('\v^(\@\@ .+ \@\@\|[<=>\|]{7}([^<=>\|]\|$))', 'bnW')..'gg'
noremap <expr>]n search('\v^(\@\@ .+ \@\@\|[<=>\|]{7}([^<=>\|]\|$))', 'nW')..'G'

" unimpaired-lines
nnoremap <silent>[<Space> :<C-U>put! =repeat(\"\n\", v:count1)<Bar>+<CR>
nnoremap <silent>]<Space> :<C-U>put =repeat(\"\n\", v:count1)<Bar>'[-<CR>
nnoremap <expr><silent>[e printf(":<C-U>move --%d<CR>", v:count1)
nnoremap <expr><silent>]e printf(":<C-U>move +%d<CR>", v:count1)
xnoremap <expr><silent>[e printf(":move '<--%d<CR>gv", v:count1)
xnoremap <expr><silent>]e printf(":move '>+%d<CR>gv", v:count1)

" unimpaired-toggling
call s:toggle('b', 'bg', 'light', 'dark')
call s:toggle('c', 'cul')
call s:toggle('d', 'diff', 'diffthis', 'diffoff')
call s:toggle('h', 'hls')
call s:toggle('i', 'ic')
call s:toggle('l', 'list')
call s:toggle('n', 'nu')
call s:toggle('r', 'rnu')
call s:toggle('s', 'spell')
call s:toggle('u', 'cuc')
call s:toggle('v', 've', 'all', '')
call s:toggle('w', 'wrap')
call s:toggle('x', 'cul', 'setl cul cuc', 'setl nocul nocuc')

" unimpaired-pasting
" [P and ]P to flip(!) linewise / charwise
nnoremap <silent>[P :<C-U>call <SID>putreg('P', v:true)<CR>
nnoremap <silent>]P :<C-U>call <SID>putreg('p', v:true)<CR>
" [p and ]p to adjust indent and put linewise
nnoremap <silent>[p :<C-U>call <SID>putreg('[p')<CR>
nnoremap <silent>]p :<C-U>call <SID>putreg(']p')<CR>
" <P and <p to put and shift left
nnoremap <silent><P :<C-U>call <SID>putreg('[p')<CR><']
nnoremap <silent><p :<C-U>call <SID>putreg(']p')<CR><']
" >P and >p to put and shift right
nnoremap <silent>>P :<C-U>call <SID>putreg('[p')<CR>>']
nnoremap <silent>>p :<C-U>call <SID>putreg(']p')<CR>>']
" =P and =p to put and re-indent
nnoremap <silent>=P :<C-U>call <SID>putreg('[p')<CR>=']
nnoremap <silent>=p :<C-U>call <SID>putreg(']p')<CR>=']

" [op ]op yop
nnoremap <silent>[op :set paste<Bar>au InsertLeave * ++once set paste&<CR>O
nnoremap <silent>]op :set paste<Bar>au InsertLeave * ++once set paste&<CR>o
nnoremap <silent>yop :set paste<Bar>au InsertLeave * ++once set paste&<CR>S

" unimpaired-encoding (except XML)
nnoremap <expr><silent>[u opera#mapto('call <SID>url_encode()')
xnoremap <expr><silent>[u opera#mapto('call <SID>url_encode()')
nnoremap <silent>[uu :call <SID>url_encode()<CR>
nnoremap <expr><silent>]u opera#mapto('call <SID>url_decode()')
xnoremap <expr><silent>]u opera#mapto('call <SID>url_decode()')
nnoremap <silent>]uu :call <SID>url_decode()<CR>
nnoremap <expr><silent>[y opera#mapto('call <SID>c_encode()')
xnoremap <expr><silent>[y opera#mapto('call <SID>c_encode()')
nnoremap <silent>[yy :call <SID>c_encode()<CR>
nnoremap <expr><silent>]y opera#mapto('call <SID>c_decode()')
xnoremap <expr><silent>]y opera#mapto('call <SID>c_decode()')
nnoremap <silent>]yy :call <SID>c_decode()<CR>
