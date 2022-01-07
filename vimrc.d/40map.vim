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
nnoremap <silent><M-F9> <cmd>call misc#guifont(v:null, v:count1)<CR>
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
" text objects: ae/ie - buffer, al/il - line, ai/ii - indent
noremap <expr><silent><plug>ae textobj#set_lines(1, '$')
noremap <expr><silent><plug>ie textobj#set_lines(nextnonblank(1), prevnonblank('$'))
noremap <expr><silent><plug>al
    \ textobj#set_chars(textobj#pos('.', 1), textobj#pos('.', col('$') - 1))
noremap <expr><silent><plug>il
    \ textobj#set_chars(textobj#pos('.', '\S'), textobj#pos('.', '\S\s*$'))
noremap <expr><silent><plug>ai textobj#indent(v:count1, 1, 0)
noremap <expr><silent><plug>ii textobj#indent(v:count1, 0, 0)
noremap <expr><silent><plug>aI textobj#indent(v:count1, 1, 1)
noremap <expr><silent><plug>iI textobj#indent(v:count1, 0, 1)
for s:textobj in ['ae', 'ie', 'al', 'il', 'ai', 'ii', 'aI', 'iI']
    execute printf('omap %s <plug>%s', s:textobj, s:textobj)
    execute printf('xmap %s <plug>%s', s:textobj, s:textobj)
endfor
