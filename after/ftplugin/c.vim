" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

let b:undo_ftplugin ..= ' | setl cino< cink< cms< cpt< fdm< kp<'
setlocal cinoptions=:0,b1,t0,(s cinkeys+=0=break;
setlocal commentstring=//%s
setlocal complete+=i foldmethod=syntax keywordprg=:Isplit
