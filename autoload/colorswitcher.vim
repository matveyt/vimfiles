" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

function! colorswitcher#next(incr)
    if !exists('g:colorswitcher#colors')
        let g:colorswitcher#colors = globpath(&runtimepath, 'colors/*.vim', 0, 1)
        call sort(map(g:colorswitcher#colors, 'fnamemodify(v:val, ":t:r")'))
    endif
    if !exists('g:colors_name')
        let g:colors_name = ''
    endif
    let l:curr = index(g:colorswitcher#colors, g:colors_name, 0, 1) + a:incr
    let l:curr %= len(g:colorswitcher#colors)
    let l:curr += l:curr < 0 ? len(g:colorswitcher#colors) : 0
    execute 'colorscheme' g:colorswitcher#colors[l:curr]
    setlocal statusline=%{g:colors_name}
    redrawstatus | sleep
    setlocal statusline<
endfunction
