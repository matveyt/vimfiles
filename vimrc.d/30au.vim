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
    if get(g:, 'GuiLoaded')
        silent! GuiAdaptiveColor 1
        silent! GuiAdaptiveFont 1
        silent! GuiAdaptiveStyle Fusion
        silent! GuiScrollBar 1
        silent! GuiTabline 0
        silent! GuiPopupmenu 0
        silent! GuiRenderLigatures 1
        silent! GuiWindowOpacity 1.0
    endif
    silent! set browsedir=buffer guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~
    silent! set guioptions-=t guioptions+=! renderoptions=type:directx scrollfocus
    call better#defaults(#{glyph: [0x1F4C2, 0x1F4C4]}, 'drvo')
    call better#defaults(#{font_list: ['Inconsolata LGC', 'JetBrains Mono',
        \ 'Liberation Mono', 'PT Mono', 'SF Mono', 'Ubuntu Mono']})
    14Font PT Mono
endfunction

function s:xterm() abort
    silent! set ttyfast
    if has('mouse_sgr')
        set ttymouse=sgr
    endif
    silent! let &termguicolors = ($TERM_PROGRAM isnot# 'Apple_Terminal')
    if !has('nvim') && ($TERM_PROGRAM is# 'mintty' || $TERM_PROGRAM is# 'tmux')
        let &t_EI = "\e[2 q"
        let &t_SR = "\e[4 q"
        let &t_SI = "\e[6 q"
    endif
endfunction

function s:main() abort
    call better#aug_remove('editorconfig', 'nvim_cmdwin', 'nvim_swapfile')
    if !exists('#FileType')
        filetype plugin indent on
        syntax enable
    endif
    set background=light
    silent! colorscheme modest
    silent! let &statusline = stalin#build('mode,buffer,,cmdloc,flags,ruler')
    if bufnr('$') == 1 && better#is_blank_buffer(1)
        Welcome
    endif
endfunction
