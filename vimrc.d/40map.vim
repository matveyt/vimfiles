" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

" remove Neovim default-mappings
mapclear | mapclear! | tmapclear

" ';' to go to the command line quickly
nnoremap ; :
xnoremap ; :
" '\;' to repeat char search forward
nnoremap <leader>; ;
xnoremap <leader>; ;

" scroll window when cursor is on the last line
nnoremap <expr>j        line('.') == line('$') ? '<C-E>' : 'j'
nnoremap <expr><Down>   line('.') == line('$') ? '<C-E>' : '<Down>'
nnoremap <expr><C-J>    line('.') == line('$') ? '<C-E>' : '<C-J>'
nnoremap <expr><C-M>    line('.') == line('$') ? '<C-E>' : '<C-M>'
nnoremap <expr><C-N>    line('.') == line('$') ? '<C-E>' : '<C-N>'

" gl to toggle register type linewise-characterwise
nmap gl <cmd>call setreg(getreginfo(v:register)->get('points_to', v:register), '',
    \ getregtype() is# 'V' ? 'av' : 'aV')<CR>
" - to set unnamed register
nmap - <cmd>call setreg('@',
    \ #{points_to: v:register is '"' ? v:count % 10 : v:register})<CR>
" + to set clipboard register
nmap + <cmd>call setreg('+',
    \ getreginfo(v:register is '"' ? v:count % 10 : v:register))<CR>
" Q to zoom current window
nmap Q <cmd>Zoom<CR>

" <F8> to set colorscheme
nmap <F8> <plug>colorscheme;
" <F9> to set &guifont; [count]<S-F9>/[count]<M-F9> to change font size
nmap <F9> <plug>font;
nmap <S-F9> <cmd>let &guifont = better#guifont(v:null, v:count1)<CR>
nmap <M-F9> <cmd>let &guifont = better#guifont(v:null, -v:count1)<CR>
" <F11> to open terminal
nmap <F11> <cmd>call term#start()<CR>
" <C-@> to insert previously inserted text and stop insert (also in Normal mode)
nnoremap <C-@> ".gP
" <Ctrl-N> to add new tab
nmap <C-N> <cmd>$tabnew<CR>
" <Ctrl-S> to save file
nmap <C-S> <cmd>update<CR>
" [count]<BS> to open FileExplorer (vim-drvo)
nnoremap <silent><BS> :<C-U>edit %:p<C-R>=repeat(':h', v:count1)<CR><CR>

" '\=' to cd to the current file's directory
nmap <leader>= <cmd>lcd %:p:h <Bar> pwd<CR>
" '\h' to show the current highlight group
nmap <leader>h <cmd>Highlight!<CR>
" '\p' to show what function we are in (like 'diff -p')
nmap <leader>p <cmd>echo getline(search('^[[:alpha:]$_]', 'bcnW'))<CR>
" '\l' to toggle location list
nmap <expr><leader>l printf('<cmd>botright l%s<CR>',
    \ getloclist(0, #{winid: 0}).winid ? 'close' : 'open')
" '\q' to toggle quickfix
nmap <expr><leader>q printf('<cmd>botright c%s<CR>',
    \ getqflist(#{winid: 0}).winid ? 'close' : 'open')
" '\s' to open scratch buffer
nmap <leader>s <cmd>split +Scratch<CR>
" '\u' to toggle undotree
nmap <leader>u <cmd>UndotreeToggle<CR>

" restore visual selection after shift
xnoremap < <gv
xnoremap > >gv
" move cursor inside quotes while typing
noremap! "" ""<Left>
noremap! '' ''<Left>

" copy-paste like Windows
vnoremap <S-Del>    "+x
vnoremap <C-Insert> "+y
vnoremap <S-Insert> "+P
nnoremap <S-Insert> "+gP
noremap! <S-Insert> <C-R>+
tmap <S-Insert> <cmd>call term#sendkeys('%', @+)<CR>

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
noremap <expr><silent><plug>ae; textobj#set_lines(1, '$')
noremap <expr><silent><plug>ie; textobj#set_lines(nextnonblank(1), prevnonblank('$'))
noremap <expr><silent><plug>al;
    \ textobj#set_chars(textobj#pos('.', 1), textobj#pos('.', col('$') - 1))
noremap <expr><silent><plug>il;
    \ textobj#set_chars(textobj#pos('.', '\S'), textobj#pos('.', '\S\s*$'))
noremap <expr><silent><plug>ai; textobj#indent(v:count1, 1, 0)
noremap <expr><silent><plug>ii; textobj#indent(v:count1, 0, 0)
noremap <expr><silent><plug>aI; textobj#indent(v:count1, 1, 1)
noremap <expr><silent><plug>iI; textobj#indent(v:count1, 0, 1)
for s:obj in ['ae', 'ie', 'al', 'il', 'ai', 'ii', 'aI', 'iI']
    execute 'omap' s:obj '<plug>'..s:obj..';'
    execute 'xmap' s:obj '<plug>'..s:obj..';'
endfor
unlet s:obj
