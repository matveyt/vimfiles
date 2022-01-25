" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

let s:enter = {}

function s:enter.gui() abort
    call better#safe('GuiAdaptiveColor 1')
    call better#safe('GuiAdaptiveFont 1')
    call better#safe('GuiAdaptiveStyle Fusion')
    call better#safe('GuiScrollBar 1')
    call better#safe('GuiTabline 1')
    call better#safe('GuiPopupmenu 0')
    call better#safe('GuiRenderLigatures 1')
    call better#safe('GuiWindowOpacity 1.0')
    call better#safe('set renderoptions=type:directx', has('directx'))
    call better#safe('set scrollfocus')
    call better#defaults(#{glyph: [0x1F4C2, 0x1F4C4]}, 'drvo')
    call better#defaults(#{fontlist: ['Inconsolata LGC', 'JetBrains Mono',
        \ 'Liberation Mono', 'PT Mono', 'SF Mono', 'Ubuntu Mono']})
    14Font PT Mono
endfunction

function s:enter.xterm() abort
    call better#safe('set termguicolors', $TERM_PROGRAM isnot# 'Apple_Terminal')
    call better#safe('set ttyfast')
    call better#safe('set ttymouse=sgr', has('mouse_sgr'))
    call better#safe("set t_EI=\e[2\\ q t_SR=\e[4\\ q t_SI=\e[6\\ q",
        \ !has('nvim') && ($TERM_PROGRAM is# 'mintty' || $TERM_PROGRAM is# 'tmux'))
endfunction

function s:enter.main() abort
    if !exists('g:colors_name')
        set background=light
        silent! colorscheme modest
    endif

    silent! let &statusline = stalin#build('mode,buffer,,flags,ruler')

    if bufnr('$') == 1 && better#is_blank_buffer()
        MRU
    endif
endfunction

function s:enter.do(what) abort
    if self->has_key(a:what) && self->get('did_'..a:what) == 0
        call self[a:what]()
        let self['did_'..a:what] = 1
    endif
endfunction

augroup vimEnter | au!
    autocmd VimEnter * ++nested
        \   call s:enter.do(better#gui_running() ? 'gui' : &t_Co >= 256 ?
        \       'xterm' : 'term')
        \ | call s:enter.do('main')
    silent! autocmd GUIEnter * ++nested call s:enter.do('gui')
    silent! autocmd UIEnter * ++nested
        \   call s:enter.do(v:event.chan > 0 ? 'gui' : 'xterm')
augroup end

if v:vim_did_enter
    call getcompletion('g:loaded_', 'var')
        \ ->filter('!empty(eval(v:val))')->map('"unlet "..v:val')->execute()
    packloadall!
    doautocmd VimEnter
endif
