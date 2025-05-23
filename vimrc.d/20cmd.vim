" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

 " :[mods]Nomove {cmd}
 " save/restore cursor "quasi-modifier"
command -nargs=+ -complete=command Nomove
    \   call better#nomove(<q-args>)

" :[mods]Sorted[!] {cmd}
" sorted "quasi-modifier"
command -bang -nargs=1 -complete=command Sorted
    \   echo join(sort(split(execute(<q-mods>..' '..<q-args>), "\n"),
    \       {s1, s2 -> <bang>(s1 ># s2) - <bang>(s1 <# s2)}), "\n")

" :Bwipeout[!]
" wipe all deleted/unloaded buffers
command -bar -bang Bwipeout
    \   call better#bwipeout(<bang>0 ? '!v:val.loaded' :
    \       '!v:val.loaded && !v:val.listed')

" :[range]CEncode[!]
" encode/decode C strings
command -range -bar -bang CEncode
    \   call better#encode(<line1>, <line2>, 'C<bang>')

" :[range]Comment[!]
" toggle comments
command -range -bar -bang Comment
    \   call better#comment(<line1>, <line2>, <bang>&pi)

" :Diff[!] [spec]
" show diff with original file or git object
command -bang -nargs=? Diff
    \   call better#diff(<q-args> ?? (<bang>0 || &modified ? '' : 'HEAD'))

" :[range]Execute [winnr]
" execute VimScript or any "shebang"-script
command -range=% -bar -nargs=? Execute
    \   call shebang#execute('%', <line1>, <line2>, <args>)

" :[count]Font [typeface]...
" set &guifont
function s:fontcomplete(A, L, P) abort
    return get(g:, 'font_list', [])->join("\n")
endfunction
command -count -nargs=? -complete=custom,s:fontcomplete Font
    \   if <count> || !empty(<q-args>)
    \ |     let &guifont = better#guifont(<q-args>, <count>)
    \ | else
    \ |     echo &guifont
    \ | endif

" :Git [args]
" invoke the stupid content tracker
function s:gitcomplete(A, L, P) abort
    return join(['add', 'branch', 'checkout', 'clone', 'commit', 'diff', 'init', 'log',
        \ 'merge', 'pull', 'push', 'remote', 'status'], "\n")
endfunction
command -nargs=* -complete=custom,s:gitcomplete Git
    \   execute '!' better#exepath('git') '-C %:p:h:S <args>'

" :Highlight[!]
" show :highlight under cursor
command -bar -bang Highlight
    \   execute <bang>0 'verbose highlight'
    \       synIDattr(synID(line('.'), col('.'), 1), 'name') ?? 'Normal'

" :Man [{number}] {name}
" Display the manual page for {name} in a section {number}
if exists(':Man') != 2 && !has('nvim')
    command -nargs=+ -complete=shellcmd Man call dist#man#GetPage(<q-mods>, <f-args>)
endif

" :[range]Trim[!]
" trim trailing/leading space
command -range=% -bar -bang Trim Nomove
    \   keepj keepp <line1>,<line2>s/\s\+$//e
    \ | if <bang>0
    \ |     <line1>,<line2>left
    \ | endif

" :[range]UrlEncode[!]
" encode/decode URLs
command -range -bar -bang UrlEncode
    \   call better#encode(<line1>, <line2>, 'URL<bang>')

" :[count]Welcome [sesdir]
" show MRU and Session files
command -count=10 -bar -nargs=? -complete=dir Welcome
    \   call welcome#show(<q-args> ?? better#stdpath('data', 'site/sessions'), <count>)

" :Zoom
" toggle current window maximized
command -bar Zoom
    \   if winnr('$') > 1 && &winwidth < 999
    \ |     let t:wrcmd = winrestcmd()
    \ |     set winminwidth=0 winminheight=0 winwidth=999 winheight=999
    \ | else
    \ |     set winminwidth& winminheight& winwidth& winheight&
    \ |     execute has_key(t:, 'wrcmd') ? remove(t:, 'wrcmd') : 'wincmd='
    \ | endif
