" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

function! statusline#get()
    let l:status  = '%#Visual#%( %{'
        \ . get(function('s:vmode2str'), 'name')
        \ . '()} %)'                            "MODE
    let l:status .= '%#CursorLine#%( %{mode()==#"n"?"NORMAL":""} %)'
    let l:status .= '%#DiffAdd#%( %{mode()==#"i"?'
        \ . get(function('s:emodes'), 'name')
        \ . '()[0]:""} %)'
    let l:status .= '%#DiffDelete#%( %{mode()==#"R"?'
        \ . get(function('s:emodes'), 'name')
        \ . '()[1]:""} %)'
    let l:status .= '%#StatusLineTerm#%( %{mode()==#"t"?"TERMNL":""} %)'
    let l:status .= '%#CursorLine#%( %{'
        \ . get(function('s:branch2str'), 'name')
        \ . '()} %)'                            "[branch]
    let l:status .= '%* %n:%<%t%( %m%) '        "buffer:file [modified]
    let l:status .= '%#CursorLine# %= '         "====================
    let l:status .= '%(%{&ft} | %)'             "type
    let l:status .= '%(%{&ff} | %)'             "format
    let l:status .= '%{empty(&fenc)?&enc:&fenc}'"encoding
    let l:status .= '%{&bomb?":bom":""} '       "bom
    let l:status .= '%* %l:%c%V %p%% '          "row:col percent%
    return l:status
endfunction

function! s:vmode2str()
    let l:vmodes = {
        \ 'v': 'VISUAL', 'V': 'V-LINE', "\<C-V>": 'V-BLOC',
        \ 's': 'SELECT', 'S': 'S-LINE', "\<C-S>": 'S-BLOC'
    \ }
    return get(l:vmodes, mode(), '')
endfunction

function! s:emodes()
    let l:emodes = {
        \ 'en': ['INSERT', 'RPLACE'],
        \ 'ru': ['ВСТВКА', 'ЗАМЕНА']
    \ }
    return get(l:emodes, &iminsert ? b:keymap_name[:4] : 'en', l:emodes['en'])
endfunction

function! s:branch2str()
    if !exists('g:loaded_fugitive') || !g:loaded_fugitive
        return ''
    endif
    let l:prefix = has('gui_running') ? nr2char(0x652f, 1) : '['
    let l:branch = fugitive#Head(-1)
    let l:suffix = has('gui_running') ? '' : ']'
    return empty(l:branch) ? '' : l:prefix . l:branch . l:suffix
endfunction
