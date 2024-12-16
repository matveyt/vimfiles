" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

" s:nextprev({letter}, {prefix})
" create mappings for :next/:previous commands
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

" unimpaired-next
call s:nextprev('a', '')
call s:nextprev('b', 'b')
call s:nextprev('l', 'l')
call s:nextprev('q', 'c')
call s:nextprev('t', 't')

" [f ]f [n ]n
nnoremap <silent>[f :<C-U>edit <C-R>=better#nextfile(-v:count1)
    \ ->fnamemodify(':.')->fnameescape()<CR><CR>
nnoremap <silent>]f :<C-U>edit <C-R>=better#nextfile(v:count1)
    \ ->fnamemodify(':.')->fnameescape()<CR><CR>
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
call s:toggle('m', 'ma')
call s:toggle('n', 'nu')
call s:toggle('r', 'rnu')
call s:toggle('s', 'spell')
call s:toggle('t', 'cc', &cc, '')
call s:toggle('u', 'cuc')
call s:toggle('v', 've', &ve, '')
call s:toggle('w', 'wrap')
call s:toggle('x', 'cul', 'setl cul cuc', 'setl nocul nocuc')

" unimpaired-pasting
nnoremap <silent>[P :<C-U>call better#putreg('V', '[P')<CR>
nnoremap <silent>]P :<C-U>call better#putreg('V', ']P')<CR>
" [p and ]p to adjust indent and put linewise
nnoremap <silent>[p :<C-U>call better#putreg('V', '[p')<CR>
nnoremap <silent>]p :<C-U>call better#putreg('V', ']p')<CR>
" <P and <p to put and shift left
nnoremap <silent><P :<C-U>call better#putreg('V', '[P')<CR><']
nnoremap <silent><p :<C-U>call better#putreg('V', ']p')<CR><']
" >P and >p to put and shift right
nnoremap <silent>>P :<C-U>call better#putreg('V', '[P')<CR>>']
nnoremap <silent>>p :<C-U>call better#putreg('V', ']p')<CR>>']
" =P and =p to put and re-indent
nnoremap <silent>=P :<C-U>call better#putreg('V', '[P')<CR>=']
nnoremap <silent>=p :<C-U>call better#putreg('V', ']p')<CR>=']

" [op ]op yop
nnoremap <silent>[op :set paste<Bar>au InsertLeave * ++once set paste&<CR>O
nnoremap <silent>]op :set paste<Bar>au InsertLeave * ++once set paste&<CR>o
nnoremap <silent>yop :set paste<Bar>au InsertLeave * ++once set paste&<CR>S

" unimpaired-encoding (except XML)
nnoremap <expr><silent>[u opera#mapto('UrlEncode')
xnoremap <expr><silent>[u opera#mapto('UrlEncode')
nnoremap <silent>[uu :UrlEncode<CR>
nnoremap <expr><silent>]u opera#mapto('UrlEncode!')
xnoremap <expr><silent>]u opera#mapto('UrlEncode!')
nnoremap <silent>]uu :UrlEncode!<CR>
nnoremap <expr><silent>[y opera#mapto('CEncode')
xnoremap <expr><silent>[y opera#mapto('CEncode')
nnoremap <silent>[yy :CEncode<CR>
nnoremap <expr><silent>]y opera#mapto('CEncode!')
xnoremap <expr><silent>]y opera#mapto('CEncode!')
nnoremap <silent>]yy :CEncode!<CR>
nnoremap <expr><silent>[C opera#mapto('CEncode')
xnoremap <expr><silent>[C opera#mapto('CEncode')
nnoremap <silent>[CC :CEncode<CR>
nnoremap <expr><silent>]C opera#mapto('CEncode!')
xnoremap <expr><silent>]C opera#mapto('CEncode!')
nnoremap <silent>]CC :CEncode!<CR>
