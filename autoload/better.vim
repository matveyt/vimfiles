" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

" better#gui_running()
" Vim/Neovim compatibility
function! better#gui_running()
    return has('gui_running') ||
        \ exists('*nvim_list_uis') && nvim_list_uis()[-1].chan > 0
endfunction

" better#win_execute({id}, {command} [, {silent}])
" Vim/Neovim compatibility
" Note: Neovim doesn't have win_execute()
function! better#win_execute(id, command, ...)
    " call win_execute() if possible
    let l:silent = get(a:, 1, 'silent')
    if exists('*win_execute')
        return win_execute(a:id, a:command, l:silent)
    endif
    " try to switch the current window
    let l:wcurr = win_getid()
    if a:id != l:wcurr && !win_gotoid(a:id)
        return
    endif
    " execute command and switch window back after that
    try | return execute(a:command, l:silent)
    finally
        if a:id != l:wcurr
            call win_gotoid(l:wcurr)
        endif
    endtry
endfunction

" better#bufwinid({expr})
" improved bufwinid():
"     - prefer current window ID if it matches;
"     - not confined to the current tab
function! better#bufwinid(buf)
    let l:bufnr = bufnr(a:buf)
    if l:bufnr == -1
        " invalid buffer
        return -1
    elseif l:bufnr == bufnr()
        " current buffer
        return win_getid()
    endif
    " find in the current tab
    let l:winid = bufwinid(l:bufnr)
    if l:winid == -1
        " find first match
        let l:winid = get(win_findbuf(l:bufnr), 0, -1)
    endif
    return l:winid
endfunction
