" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" disable default-mappings
if has('nvim-0.6.0')
    silent! nunmap Y
    silent! nunmap <C-L>
    silent! iunmap <C-U>
    silent! iunmap <C-W>
endif

" extra mappings as in tpope/vim-unimpaired
call unimpaired#emulate()

" ';' to get to the command line quickly
nnoremap ; :
xnoremap ; :
" '\;' to repeat char search forward
nnoremap <leader>; ;
xnoremap <leader>; ;
" Q to zoom current window
nnoremap <silent>Q <cmd>Zoom<CR>
" <Space> to toggle fold
nnoremap <Space> za
" <F8> to set colorscheme
nmap <F8> <plug>colorscheme
" <F9> to set &guifont; [count]<C-F9>/[count]<S-F9> to change font size
nmap <F9> <plug>font
nnoremap <silent><C-F9> <cmd>call misc#guifont(v:null, v:count1)<CR>
nnoremap <silent><S-F9> <cmd>call misc#guifont(v:null, -v:count1)<CR>
" <F11> to open terminal
nnoremap <silent><F11> <cmd>call term#start()<CR>
" <Ctrl-N> to add new tab
nnoremap <silent><C-N> <cmd>$tabnew<CR>
" <Ctrl-S> to save file
nnoremap <silent><C-S> <cmd>update<CR>
" move cursor inside quotes while typing
noremap! "" ""<Left>
noremap! '' ''<Left>
" restore visual selection after shift
xnoremap < <gv
xnoremap > >gv
" copy-paste like Windows
vnoremap <S-Del>    "+d
vnoremap <C-Insert> "+y
vnoremap <S-Insert> "+p
nnoremap <S-Insert> "+gP
noremap! <S-Insert> <C-R>+
" [count]<BS> to open "File Explorer" (vim-drvo)
nnoremap <silent><BS> :<C-U>edit %:p<C-R>=repeat(':h', v:count1)<CR><CR>
" '\=' to cd to the current file's directory
nnoremap <leader>= <cmd>lcd %:p:h <Bar> pwd<CR>
" '\h' to show the current highlight group
nnoremap <silent><leader>h <cmd>Highlight!<CR>
" '\p' to show what function we are in (like 'diff -p')
nnoremap <leader>p <cmd>echo getline(search('^[[:alpha:]$_]', 'bcnW'))<CR>
" '\l' to toggle location list
nnoremap <expr><silent><leader>l printf('<cmd>l%s<CR>',
    \ getloclist(0, #{winid: 0}).winid ? 'close' : 'open')
" '\q' to toggle quickfix
nnoremap <expr><silent><leader>q printf('<cmd>c%s<CR>',
    \ getqflist(#{winid: 0}).winid ? 'close' : 'open')
" '\s' to open scratch buffer
nnoremap <silent><leader>s <cmd>split +Scratch<CR>
" '\u' to toggle undotree
nnoremap <leader>u <cmd>UndotreeToggle<CR>
" '\x' to execute command and put output into a buffer
" '\X' to eval expression and put result into a buffer
nnoremap <silent><leader>x <cmd>put =trim(execute(input(':', '', 'command')))<CR>
nnoremap <silent><leader>X <cmd>put =eval(input('=', '', 'expression'))<CR>
" browse (a)rglist, (b)uffers, (f)ind, command-line (H)istory, (m)arks, (S)essions,
" script(n)ames, (o)ldfiles, (r)egisters, (S)essions, (t)emplates, (w)indows;
" '\\' for everything
nmap <leader><leader> <plug>pick
nmap <leader>a <plug>args
nmap <leader>b <plug>buffers
nmap <leader>f <plug>find
nmap <leader>H <plug>history
nmap <leader>m <plug>marks
nmap <leader>n <plug>scriptnames
nmap <leader>o <plug>oldfiles
nmap <leader>r <plug>registers
nmap <leader>S <plug>sessions
nmap <leader>t <plug>templates
nmap <leader>w <plug>windows
" gc to toggle comments
nnoremap <expr><silent>gc opera#mapto('Comment!')
xnoremap <expr><silent>gc opera#mapto('Comment!')
nnoremap <silent>gcc :Comment!<CR>
" gs to sort selection text
nnoremap <expr><silent>gs opera#mapto('sort')
xnoremap <expr><silent>gs opera#mapto('sort')
nnoremap <silent>gss :sort<CR>
" gx to execute script
nnoremap <expr><silent>gx opera#mapto('Execute', 'line')
xnoremap <expr><silent>gx opera#mapto('Execute', 'line')
nnoremap <silent>gxx :Execute<CR>
" g<Space> to trim trailing whitespace
nnoremap <expr><silent>g<Space> opera#mapto('Trim')
xnoremap <expr><silent>g<Space> opera#mapto('Trim')
nnoremap <silent>g<Space><Space> :Trim<CR>

" my text objects: ae/ie - buffer, al/il - line, ai/ii - indent
noremap <expr><silent><plug>ae textobj#set_lines(1, '$')
noremap <expr><silent><plug>ie textobj#set_lines(nextnonblank(1), prevnonblank('$'))
noremap <expr><silent><plug>al
    \ textobj#set_chars(textobj#pos('.', 1), textobj#pos('.', col('$') - 1))
noremap <expr><silent><plug>il
    \ textobj#set_chars(textobj#pos('.', '\S'), textobj#pos('.', '\S\s*$'))
noremap <expr><silent><plug>ai textobj#indent(v:count1, 1, 0)
noremap <expr><silent><plug>ii textobj#indent(v:count1, 0, 0)
noremap <expr><silent><plug>aI textobj#indent(v:count1, 1, 1)
noremap <expr><silent><plug>iI textobj#indent(v:count1, 0, 0)
for _ in ['ae', 'ie', 'al', 'il', 'ai', 'ii', 'aI', 'iI']
    execute printf('omap %s <plug>%s', _, _)
    execute printf('xmap %s <plug>%s', _, _)
endfor

" implement various pickers
nnoremap <silent><plug>pick <cmd>call misc#pick('pick',
    \ '%{substitute(maparg("<lt>plug>"..items[result - 1], "n"), "<[-[:alnum:]]\\+>",
        \ "", "g")}',
    \ ['args', 'buffers', 'colorscheme', 'find', 'font', 'history', 'marks', 'oldfiles',
        \ 'registers', 'scriptnames', 'sessions', 'templates', 'windows'])<CR>
nnoremap <silent><plug>args <cmd>call misc#pick('args', '%{result}argument', argv())<CR>
nnoremap <silent><plug>buffers <cmd>call misc#pick('buffer',
    \ '%{name} %{items[result - 1].bufnr}',
    \ getbufinfo({'buflisted': v:count == 0}),
    \ 'printf("%2d %s", v:val.bufnr, empty(v:val.name) ? "[No Name]" :
        \ fnamemodify(v:val.name, ":t"))')<CR>
nnoremap <silent><plug>colorscheme <cmd>call misc#pick('colorscheme')<CR>
nnoremap <silent><plug>find <cmd>call misc#pick('find')<CR>
nnoremap <silent><plug>font <cmd>call misc#pick('Font', v:null, g:fontlist)<CR>
nnoremap <silent><plug>history <cmd>call misc#pick('history',
    \ '%{lines[result - 1]}',
    \ range(1, v:count ? v:count : 50),
    \ 'histget(":", -v:val)')<CR>
nnoremap <silent><plug>marks <cmd>call misc#pick('marks',
    \ 'normal! `%{items[result - 1].mark[1:]}',
    \ getmarklist('') + getmarklist(),
    \ 'printf("%s %6d:%-4d %s", v:val.mark[1:], v:val.pos[1], v:val.pos[2],
        \ has_key(v:val, "file") ? fnamemodify(v:val.file, ":t") :
            \ getline(v:val.pos[1]))')<CR>
nnoremap <silent><plug>oldfiles <cmd>call misc#pick('oldfiles',
    \ 'edit %{fnameescape(items[result - 1])}',
    \ better#oldfiles(v:count))<CR>
nnoremap <silent><plug>registers <cmd>call misc#pick('registers',
    \ 'normal! "%{items[result - 1]}p',
    \ split('"0123456789-abcdefghijklmnopqrstuvwxyz:.%#=*+/', '\zs')
        \ ->filter('!empty(getreg(v:val))'),
    \ 'printf("%s %.*s", v:val, &columns / 2, strtrans(getreg(v:val)))')<CR>
nnoremap <silent><plug>scriptnames <cmd>call misc#pick('scriptnames',
    \ '%{result}%{name}',
    \ split(execute('scriptnames'), "\n"),
    \ 'v:val[1:]')<CR>
nnoremap <silent><plug>sessions <cmd>call misc#pick('sessions',
    \ 'source %{fnameescape(items[result - 1])}',
    \ glob(better#stdpath('data', 'site/sessions/*.vim'), v:false, v:true),
    \ 'fnamemodify(v:val, ":t")')<CR>
nnoremap <silent><plug>templates <cmd>call misc#pick('templates',
    \ '-read ++edit %{fnameescape(items[result - 1])} <Bar>
        \ Nomove ''[,'']s/\v\%\{([^}]+)\}/\=eval(submatch(1))/ge',
    \ glob(better#stdpath('data', 'site/templates/%s/*',
        \ better#or(&filetype, 'empty')), v:false, v:true),
    \ 'fnamemodify(v:val, ":t")')<CR>
nnoremap <silent><plug>windows <cmd>call misc#pick('windows',
    \ 'call win_gotoid(%{items[result - 1].winid})',
    \ getwininfo()->sort({w1, w2 -> w1.winid - w2.winid}),
    \ 'printf("%d %s", v:val.winid, empty(bufname(v:val.bufnr)) ? "#"..v:val.bufnr :
        \ fnamemodify(bufname(v:val.bufnr), ":t"))')<CR>
