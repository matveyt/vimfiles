" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

setlocal commentstring=//%s

let b:undo_ftplugin .= ' | setl cino< cink< cpt< fdm<'
setlocal cinoptions=:0,b1,t0,(s cinkeys+=0=break;
setlocal complete+=i foldmethod=syntax

compiler gcc
let &l:path = misc#gcc_include()->insert('.')->add(',')->join(',')
