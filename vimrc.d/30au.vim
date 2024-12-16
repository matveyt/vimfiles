" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

augroup vimrc | au!
    " late init
    autocmd VimEnter * ++nested
        \   call better#once(better#gui_running() ? 'gui' : (&t_Co >= 256) ? 'xterm' :
        \       'term')
        \ | call better#once('main')
    silent! autocmd GUIEnter * ++nested call better#once('gui')
    silent! autocmd UIEnter * ++nested call better#once(v:event.chan > 0 ? 'gui' :
        \       'xterm')
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
        \ |     call printf('
        \               silent! undojoin
        \           |   keepj keepp 1,%ds/\v\C%s\s*\zs.*/%s/e',
        \           min([&modelines, line('$')]), '%(Last Change|Date):',
        \           strftime('%Y %b %d'))->better#nomove()
        \ |     execute 'language time' remove(s:, 'lc_time')
        \ | endif
    " shut off &hlsearch
    autocmd CursorHold,InsertEnter * eval !v:hlsearch || feedkeys("\<cmd>noh\r")
    " save session on exit
    autocmd VimLeavePre *
        \   if !v:dying
        \ |     call better#bwipeout('v:val.bufnr->getbufvar("&ft") =~# "^git"')
        \ |     if !empty(v:this_session)
        \ |         mksession! `=v:this_session`
        \ |     endif
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
    call better#safe('set browsedir=buffer')
    call better#safe('set guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~')
    call better#safe('set guioptions-=t')
    call better#safe('set guioptions+=!')
    call better#safe('set renderoptions=type:directx')
    call better#safe('set scrollfocus')
    call better#defaults(#{glyph: [0x1F4C2, 0x1F4C4]}, 'drvo')
    call better#defaults(#{font_list: ['Inconsolata LGC', 'JetBrains Mono',
        \ 'Liberation Mono', 'PT Mono', 'SF Mono', 'Ubuntu Mono']})
    14Font PT Mono
endfunction

function s:xterm() abort
    call better#safe('set ttyfast')
    if has('mouse_sgr')
        set ttymouse=sgr
    endif
    let &termguicolors = ($TERM_PROGRAM isnot# 'Apple_Terminal')
    if !has('nvim') && ($TERM_PROGRAM is# 'mintty' || $TERM_PROGRAM is# 'tmux')
        let &t_EI = "\e[2 q"
        let &t_SR = "\e[4 q"
        let &t_SI = "\e[6 q"
    endif
endfunction

function s:main() abort
    if !exists('#filetypeplugin#FileType')
        filetype plugin on
    endif
    if !exists('#filetypeindent#FileType')
        filetype indent on
    endif
    if !exists('#syntaxset#FileType')
        syntax enable
    endif
    call better#aug_remove('editorconfig', 'nvim_cmdwin', 'nvim_swapfile')

    set background=light
    silent! colorscheme modest
    silent! let &statusline = stalin#build('mode,buffer,,cmdloc,flags,ruler')

    if bufnr('$') == 1 && better#is_blank_buffer(1)
        Welcome
    endif
endfunction
