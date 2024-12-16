" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

" Show Sessions, Marks & MRU files
function! welcome#show(sesdir='~', max=10) abort
    let l:header =<< END
 _    _      _                            _          _   _ _           _
| |  | |    | |                          | |        | | | (_)         | |
| |  | | ___| | ___ ___  _ __ ___   ___  | |_ ___   | | | |_ _ __ ___ | |
| |/\| |/ _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \  | | | | | '_ ` _ \| |
\  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) | \ \_/ / | | | | | |_|
 \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/   \___/|_|_| |_| |_(_)

END
    if !better#is_blank_buffer()
        new
    endif
    call setline(1, l:header)
    call s:add_group('Session', glob(fnamemodify(a:sesdir, ':p')..'*.vim', 0, 1))
    call s:add_group('Mark', better#call('getmarklist'))
    call s:add_group('MRU', v:oldfiles[: a:max - 1])

    setlocal bufhidden=wipe buftype=nofile cursorline matchpairs=
    setlocal nomodifiable nonumber norelativenumber nospell noswapfile nowrap
    syntax match Title /^[^[].*$/
    syntax match Comment /^\[[0-9A-Z]\+\] \zs.\+[\/]/
    nnoremap <buffer><expr><silent><CR> <SID>on_enter()
    nnoremap <buffer><expr><silent><kEnter> <SID>on_enter()
    nnoremap <buffer><expr><silent><2-LeftMouse> <SID>on_enter()
    nnoremap <buffer><expr><silent>q <SID>on_quit()
endfunction

function s:add_group(title, items) abort
    if !empty(a:items)
        call append('$', ['', a:title] + map(a:items[:], {k, v ->
            \ type(v) is v:t_string ? printf('[%d] %s', k, v) :
            \ printf('[%s] %s:%d', v.mark[1:], v.file, v.pos[1])}))
    endif
endfunction

function s:on_enter() abort
    let l:group = getline(search('^\a\+$', 'bnW'))
    let l:item = matchlist(getline('.'), '^\[\([0-9A-Z]\+\)\] \(.*\)')
    if empty(l:group) || empty(l:item)
        return "\r"
    elseif l:group is# 'Mark'
        return '`'..l:item[1]
    else
        return printf(":%s %s\r", l:group is# 'Session' ? 'source' : 'edit',
            \ fnameescape(l:item[2]))
    endif
endfunction

function s:on_quit() abort
    return printf(":%s\r", tabpagenr('$') > 1 || winnr('$') > 1 ? 'close' : 'enew')
endfunction
