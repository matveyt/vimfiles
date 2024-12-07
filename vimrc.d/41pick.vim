" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" browse (a)rglist, (b)uffers, (f)ind, command-line (H)istory, (m)arks, (S)essions,
" script(n)ames, (o)ldfiles, (r)egisters, (S)essions, (t)emplates, (w)indows;
" '\\' for everything
nmap <leader><leader> <plug>pick;
nmap <leader>a <plug>args;
nmap <leader>b <plug>buffers;
"nmap <leader>c <plug>colorscheme;
nmap <leader>f <plug>find;
"nmap <leader>F <plug>font;
nmap <leader>H <plug>history;
nmap <leader>m <plug>marks;
nmap <leader>n <plug>scriptnames;
nmap <leader>o <plug>oldfiles;
nmap <leader>r <plug>registers;
nmap <leader>S <plug>sessions;
nmap <leader>t <plug>templates;
nmap <leader>w <plug>windows;

nmap <plug>pick; <cmd>call popup#pick('pick',
    \ '{substitute(maparg("<lt>plug>"..items[result - 1]..";", "n"),
        \ "<[-[:alnum:]]\\+>", "", "g")}',
    \ ['args', 'buffers', 'colorscheme', 'find', 'font', 'history', 'marks', 'oldfiles',
        \ 'registers', 'scriptnames', 'sessions', 'templates', 'windows'])<CR>

nmap <plug>args; <cmd>call popup#pick('args', 'argument {result}', argv())<CR>
nmap <plug>colorscheme; <cmd>call popup#pick('colorscheme')<CR>
nmap <plug>find; <cmd>call popup#pick('find')<CR>
nmap <plug>font; <cmd>call popup#pick('Font')<CR>

nmap <plug>buffers; <cmd>call popup#pick('buffer',
    \ '{name} {items[result - 1].bufnr}',
    \ getbufinfo({'buflisted': v:count == 0}),
    \ 'printf("%2d %s", v:val.bufnr, empty(v:val.name) ?
        \ better#call("gettext", "[No Name]") : fnamemodify(v:val.name, ":t"))')<CR>

nmap <plug>history; <cmd>call popup#pick('history',
    \ '{lines[result - 1]}',
    \ range(1, v:count ? v:count : 50),
    \ 'histget(":", -v:val)')<CR>

nmap <plug>marks; <cmd>call popup#pick('marks',
    \ 'normal! `{items[result - 1].mark[1:]}',
    \ getmarklist('') + getmarklist(),
    \ 'printf("%s %6d:%-4d %s", v:val.mark[1:], v:val.pos[1], v:val.pos[2],
        \ has_key(v:val, "file") ? fnamemodify(v:val.file, ":t") :
            \ getline(v:val.pos[1]))')<CR>

nmap <plug>oldfiles; <cmd>call popup#pick('oldfiles',
    \ 'edit {fnameescape(items[result - 1])}',
    \ v:oldfiles[: v:count ? v:count - 1 : 9])<CR>

nmap <plug>registers; <cmd>call popup#pick('registers',
    \ 'normal! "{items[result - 1]}p',
    \ split('"0123456789-abcdefghijklmnopqrstuvwxyz:.%#=*+/', '\zs')
        \ ->filter('!empty(getreg(v:val))'),
    \ 'printf("%s %.*s", v:val, &columns / 2, strtrans(getreg(v:val)))')<CR>

nmap <plug>scriptnames; <cmd>call popup#pick('scriptnames',
    \ '{name} {result}',
    \ split(execute('scriptnames'), "\n"),
    \ 'v:val[1:]')<CR>

nmap <plug>sessions; <cmd>call popup#pick('sessions',
    \ 'source {fnameescape(items[result - 1])}',
    \ glob(better#stdpath('data', 'site/sessions/*.vim'), v:false, v:true),
    \ 'fnamemodify(v:val, ":t")')<CR>

nmap <plug>templates; <cmd>call popup#pick('templates',
    \ '-read ++edit {fnameescape(items[result - 1])} <Bar>
    \ Nomove ''[,''] s/{"{"}\([^}]\+\)}/\=eval(submatch(1))/ge',
    \ glob(better#stdpath('data', 'site/templates/%s/*', &filetype ?? 'empty'),
        \ v:false, v:true),
    \ 'fnamemodify(v:val, ":t")')<CR>

nmap <plug>windows; <cmd>call popup#pick('windows',
    \ 'call win_gotoid({items[result - 1].winid})',
    \ getwininfo()->sort({w1, w2 -> w1.winid - w2.winid}),
    \ 'printf("%d %s", v:val.winid, fnamemodify(bufname(v:val.bufnr), ":t") ??
        \ "[buffer "..v:val.bufnr.."]")')<CR>
