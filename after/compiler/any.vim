" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

let s:name = expand('<script>:t:r')

if !exists('current_compiler')
    let current_compiler = s:name
    CompilerSet errorformat=
        \make:\ ***\ [%f:%l:\ %m,
        \%f:%l:\ %m 
endif

execute 'CompilerSet path=' .. remove(s:, 'name')
    \ ->cc#include()->insert('./h;/')->insert('.')->join(',')
