" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

nmap <plug>pick <cmd>call misc#pick('pick',
    \ '%{substitute(maparg("<lt>plug>"..items[result - 1], "n"), "<[-[:alnum:]]\\+>",
        \ "", "g")}',
    \ ['args', 'buffers', 'colorscheme', 'find', 'font', 'history', 'marks', 'oldfiles',
        \ 'registers', 'scriptnames', 'sessions', 'templates', 'windows'])<CR>

nmap <plug>args <cmd>call misc#pick('args', '%{result}argument', argv())<CR>
nmap <plug>colorscheme <cmd>call misc#pick('colorscheme')<CR>
nmap <plug>find <cmd>call misc#pick('find')<CR>
nmap <plug>font <cmd>call misc#pick('Font')<CR>

nmap <plug>buffers <cmd>call misc#pick('buffer',
    \ '%{name} %{items[result - 1].bufnr}',
    \ getbufinfo({'buflisted': v:count == 0}),
    \ 'printf("%2d %s", v:val.bufnr, empty(v:val.name) ? better#gettext("[No Name]") :
        \ fnamemodify(v:val.name, ":t"))')<CR>

nmap <plug>history <cmd>call misc#pick('history',
    \ '%{lines[result - 1]}',
    \ range(1, v:count ? v:count : 50),
    \ 'histget(":", -v:val)')<CR>

nmap <plug>marks <cmd>call misc#pick('marks',
    \ 'normal! `%{items[result - 1].mark[1:]}',
    \ getmarklist('') + getmarklist(),
    \ 'printf("%s %6d:%-4d %s", v:val.mark[1:], v:val.pos[1], v:val.pos[2],
        \ has_key(v:val, "file") ? fnamemodify(v:val.file, ":t") :
            \ getline(v:val.pos[1]))')<CR>

nmap <plug>oldfiles <cmd>call misc#pick('oldfiles',
    \ 'edit %{fnameescape(items[result - 1])}',
    \ v:oldfiles[: v:count ? v:count - 1 : 9])<CR>

nmap <plug>registers <cmd>call misc#pick('registers',
    \ 'normal! "%{items[result - 1]}p',
    \ split('"0123456789-abcdefghijklmnopqrstuvwxyz:.%#=*+/', '\zs')
        \ ->filter('!empty(getreg(v:val))'),
    \ 'printf("%s %.*s", v:val, &columns / 2, strtrans(getreg(v:val)))')<CR>

nmap <plug>scriptnames <cmd>call misc#pick('scriptnames',
    \ '%{result}%{name}',
    \ split(execute('scriptnames'), "\n"),
    \ 'v:val[1:]')<CR>

nmap <plug>sessions <cmd>call misc#pick('sessions',
    \ 'source %{fnameescape(items[result - 1])}',
    \ glob(better#stdpath('data', 'site/sessions/*.vim'), v:false, v:true),
    \ 'fnamemodify(v:val, ":t")')<CR>

nmap <plug>templates <cmd>call misc#pick('templates',
    \ '-read ++edit %{fnameescape(items[result - 1])} <Bar>
        \ Nomove ''[,'']s/\v\%\{([^}]+)\}/\=eval(submatch(1))/ge',
    \ glob(better#stdpath('data', 'site/templates/%s/*',
        \ better#or(&filetype, 'empty')), v:false, v:true),
    \ 'fnamemodify(v:val, ":t")')<CR>

nmap <plug>windows <cmd>call misc#pick('windows',
    \ 'call win_gotoid(%{items[result - 1].winid})',
    \ getwininfo()->sort({w1, w2 -> w1.winid - w2.winid}),
    \ 'printf("%d %s", v:val.winid, empty(bufname(v:val.bufnr)) ? "#"..v:val.bufnr :
        \ fnamemodify(bufname(v:val.bufnr), ":t"))')<CR>
