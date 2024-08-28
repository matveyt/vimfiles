" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

augroup vimrc | au!
    " late init
    autocmd VimEnter * ++nested
        \   call misc#once(better#gui_running() ? 'gui' :
        \       &t_Co >= 256 ? 'xterm' : 'term')
        \ | call misc#once('main')
    silent! autocmd GUIEnter * ++nested call misc#once('gui')
    silent! autocmd UIEnter * ++nested call misc#once(v:event.chan > 0 ? 'gui' : 'xterm')
    " :h restore-cursor
    " 'q' to close special windows/buffers, such as 'help'
    autocmd BufWinEnter *
        \   if empty(&buftype)
        \ |     call setpos('.', getpos("'\""))
        \ | else
        \ |     execute 'nn <buffer><expr>q empty(reg_recording()) ? ''<C-W>c'' : ''q'''
        \ | endif
    " update timestamp before saving buffer
    autocmd BufWrite *
        \   if &modified && &modeline && &modelines > 0
        \ |     let s:lc_time = v:lc_time
        \ |     language time C
        \ |     call misc#nomove('
        \               silent! undojoin
        \           |   keepj keepp 1,%ds/\v\C%s\s*\zs.*/%s/e',
        \           min([&modelines, line('$')]), '%(Last Change|Date):',
        \           strftime('%Y %b %d'))
        \ |     execute 'language time' remove(s:, 'lc_time')
        \ | endif
    " adjust some buffers
    autocmd FileType man,qf setlocal colorcolumn& cursorline& list&
    " save session on exit
    autocmd VimLeavePre *
        \   if !v:dying
        \ |     call misc#bwipeout('v:val.bufnr->getbufvar("&ft") =~# "^git"')
        \ |     call better#safe('mksession! `=v:this_session`', !empty(v:this_session))
        \ | endif
augroup end

function s:gui() abort
    call better#safe('GuiAdaptiveColor 1')
    call better#safe('GuiAdaptiveFont 1')
    call better#safe('GuiAdaptiveStyle Fusion')
    call better#safe('GuiScrollBar 1')
    call better#safe('GuiTabline 0')
    call better#safe('GuiPopupmenu 0')
    call better#safe('GuiRenderLigatures 1')
    call better#safe('GuiWindowOpacity 1.0')
    call better#safe('set guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~')
    call better#safe('set renderoptions=type:directx')
    call better#safe('set scrollfocus')
    call better#defaults(#{glyph: [0x1F4C2, 0x1F4C4]}, 'drvo')
    call better#defaults(#{fontlist: ['Inconsolata LGC', 'JetBrains Mono',
        \ 'Liberation Mono', 'PT Mono', 'SF Mono', 'Ubuntu Mono']})
    14Font PT Mono
endfunction

function s:xterm() abort
    call better#safe('set termguicolors', $TERM_PROGRAM isnot# 'Apple_Terminal')
    call better#safe('set ttyfast')
    call better#safe('set ttymouse=sgr', has('mouse_sgr'))
    call better#safe("set t_EI=\e[2\\ q t_SR=\e[4\\ q t_SI=\e[6\\ q",
        \ !has('nvim') && ($TERM_PROGRAM is# 'mintty' || $TERM_PROGRAM is# 'tmux'))
endfunction

function s:main() abort
    call misc#aug_remove('editorconfig', 'nvim_cmdwin')
    silent! let &statusline = stalin#build('mode,buffer,,flags,ruler')
    if !exists('g:colors_name')
        set background=light
        silent! colorscheme modest
    endif

    if bufnr('$') == 1 && better#is_blank_buffer(1)
        Welcome
    endif
endfunction
