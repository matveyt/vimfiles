" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" ';' to get to the command line quickly
nnoremap ; :
xnoremap ; :
" '\;' to repeat char search forward
nnoremap <leader>; ;
xnoremap <leader>; ;
" Q to zoom current window
nnoremap <silent>Q :Zoom<CR>
" <Space> to toggle fold
nnoremap <Space> za
" <F8> to set colorscheme
nnoremap <silent><F8> :call misc#command('colorscheme')<CR>
" <F9> to set new &guifont
" [count]<C-F9>/[count]<S-F9> to change font size
nnoremap <silent><F9> :call misc#command('Font', g:fontlist)<CR>
nnoremap <silent><C-F9> :<C-U>call misc#guifont(v:null, v:count1)<CR>
nnoremap <silent><S-F9> :<C-U>call misc#guifont(v:null, -v:count1)<CR>
" <F11> to open terminal
nnoremap <silent><F11> :call term#start()<CR>
" <Ctrl-N> to add new tab
nnoremap <silent><C-N> :$tabnew<CR>
" <Ctrl-S> to save file
nnoremap <silent><C-S> :update<CR>
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
nnoremap <leader>= :lcd %:p:h <Bar> pwd<CR>
" edit (a)rglist, (b)uffer, (f)ind, script(n)ames, (o)ldfiles, (w)indows
nnoremap <silent><leader>a :call misc#command('args', argv(), 'argument ${result}')<CR>
nnoremap <silent><leader>b :call misc#command('buffer', map(getbufinfo({'buflisted': 1}),
    \ {_, v -> printf('%2d %s', v.bufnr, better#or(fnamemodify(bufname(v.bufnr), ':t'),
    \ '[No Name]'))}), '${cmd} ${split(items[result - 1])[0]}')<CR>
nnoremap <silent><leader>f :call misc#command('find')<CR>
nnoremap <silent><leader>n :call misc#command('scriptnames',
    \ map(split(execute('scriptnames'), "\n"), 'v:val[1:]'), '${cmd} ${result}')<CR>
nnoremap <silent><leader>o :<C-U>call misc#command('oldfiles', better#oldfiles(v:count),
    \ 'edit ${items[result - 1]}')<CR>
nnoremap <silent><leader>w :call misc#command('windows', map(sort(getwininfo(),
    \ {w1, w2 -> w1.winid - w2.winid}), {_, v -> printf('%d %s', v.winid,
    \ better#or(fnamemodify(bufname(v.bufnr), ':t'), '#'..v.bufnr))}),
    \ 'call win_gotoid(${split(items[result - 1])[0]})')<CR>
" '\h' to show the current highlight group
nnoremap <silent><leader>h :Highlight!<CR>
" '\p' to show what function we are in (like 'diff -p')
nnoremap <leader>p :echo getline(search('^[[:alpha:]$_]', 'bcnW'))<CR>
" '\l' to toggle location list
nnoremap <expr><silent><leader>l printf(":l%s\<CR>",
    \ getloclist(0, {'winid': 0}).winid ? 'close' : 'open')
" '\q' to toggle quickfix
nnoremap <expr><silent><leader>q printf(":c%s\<CR>",
    \ getqflist({'winid': 0}).winid ? 'close' : 'open')
" '\s' to open scratch buffer
nnoremap <silent><leader>s :split +Scratch<CR>
" '\u' to toggle undotree
nnoremap <leader>u :UndotreeToggle<CR>
" '\x' to execute command and put output into a buffer
" '\X' to eval expression and put result into a buffer
nnoremap <silent><leader>x :put =trim(execute(input(':', '', 'command')))<CR>
nnoremap <silent><leader>X :put =eval(input('=', '', 'expression'))<CR>
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

" extra mappings like in tpope/vim-unimpaired
call unimpaired#emulate()
