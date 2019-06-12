" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

augroup vimrc | au!
    " C/C++ specific stuff
    autocmd Syntax c,cpp setlocal equalprg=indent foldmethod=syntax
    " minor color scheme fixes
    autocmd ColorScheme * hi! link SignColumn FoldColumn
    autocmd ColorScheme industry hi! link CursorLine Normal
    " 'q' to close a non-modifiable window/buffer (e.g. 'help')
    autocmd BufWinEnter * if !&modifiable | nnoremap <buffer>q ZQ | endif
    " <F5> to execute script
    autocmd FileType vim nnoremap <buffer><silent><F5> :update \| source %<CR>
    autocmd FileType sh  nnoremap <buffer><silent><F5> :update \|
        \ execute 'terminal' &shell expand('%:S')<CR>
    " save GUI session on exit
    " note: use 'gvim -S' to load the session
    autocmd VimLeavePre * if has('gui_running')
    autocmd VimLeavePre *     execute 'mks!' empty(v:this_session) ?
        \                         '~/Session.vim' : v:this_session
    autocmd VimLeavePre * endif
augroup end
