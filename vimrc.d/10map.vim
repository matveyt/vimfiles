" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" ';' to get to the command line quickly
noremap ; :
" ',' to repeat char search forward
noremap , ;
" '\,' to repeat char search backward
noremap <Leader>, ,
" <Space> to toggle fold
noremap <Space> za
" '\=' to cd to the current file's directory
nnoremap <Leader>= :lcd %:p:h \| pwd<CR>
" '\l' to show what function we are in (like 'diff -p')
nnoremap <Leader>l :echo getline(search('^[[:alpha:]$_]', 'bcnW'))<CR>
" <F4> to find file in path and open it
nnoremap <F4> :find<Space>
" <F12> to open terminal window
nnoremap <silent><F12> :terminal<CR>
" <Ctrl-N> to open new tab
nnoremap <silent><C-N> :silent tabedit .<CR>
" <Ctrl-S> to save file
nnoremap <silent><C-S> :update<CR>
" move cursor inside quotes while typing
inoremap "" ""<Left>
inoremap '' ''<Left>
" restore visual selection after an indent
vnoremap < <gv
vnoremap > >gv
" copy-paste like Windows
vnoremap <S-Del>    "+d
vnoremap <C-Insert> "+y
vnoremap <S-Insert> "+p
nnoremap <S-Insert> "+gP
noremap! <S-Insert> <C-R>+
