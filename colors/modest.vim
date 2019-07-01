" Vim color file
" Maintainer:   matveyt
" Last Change:  2019 Jun 30
" URL:          https://github.com/matveyt/vimfiles/colors

hi clear
if exists('g:syntax_on')
    syntax reset
endif

let g:colors_name = 'modest'

let s:palette = {}
let s:palette.Eigengrau = ['Black', 234, '#16161d']
let s:palette.Grey19 = ['NONE', 236, '#272733']
let s:palette.GreyGreen = ['DarkGrey', 242, '#5e716a']
let s:palette.AshGrey = ['LightGrey', 250, '#b2beb5']
let s:palette.Grey85 = ['NONE', 187, '#e6e6cf']
let s:palette.Beige = ['White', 230, '#f5f5dc']
let s:palette.Sienna = ['Brown', 130, '#882d17']
let s:palette.Cocoa = ['Brown', 166, '#d2691e']
let s:palette.Mantis = ['DarkGreen', 77, '#74c365']
let s:palette.EgyptianBlue = ['DarkBlue', 19, '#1034a6']
let s:palette.Aquamarine = ['Cyan', 122, '#7fffd4']

function! s:hilite(group, fg, bg, ...)
    let l:fg = get(s:palette, a:fg, [a:fg])
    let l:bg = get(s:palette, a:bg, [a:bg])
    if !a:0
        let l:term = ''
    elseif stridx(a:1, '=') != -1
        let l:term = a:1
    else
        let l:term = 'term=' . a:1 . ' cterm=' . a:1 . ' gui=' . a:1
    endif
    let l:ctermfg = 'ctermfg=' . get(l:fg, &t_Co>=256, l:fg[0])
    let l:ctermbg = 'ctermbg=' . get(l:bg, &t_Co>=256, l:bg[0])
    let l:guifg = 'guifg=' . get(l:fg, 2, l:fg[0])
    let l:guibg = 'guibg=' . get(l:bg, 2, l:bg[0])
    execute 'hi' a:group l:term l:ctermfg l:ctermbg l:guifg l:guibg
endfunction

function! s:hilink(to_group, ...)
    for l:from_group in a:000
        execute 'hi! link' l:from_group a:to_group
    endfor
endfunction

if &bg ==# 'dark'
    call s:hilite('Normal', 'AshGrey', 'Eigengrau')
    call s:hilite('Comment', 'GreyGreen', 'NONE')
    call s:hilite('Constant', 'Mantis', 'NONE')
    call s:hilite('CursorLine', 'NONE', 'Grey19', 'NONE')
    call s:hilite('Error', 'fg', 'Sienna')
    call s:hilite('TabLine', 'NONE', 'GreyGreen', 'underline')
    call s:hilite('Underlined', 'fg', 'Sienna', 'underline')
    call s:hilite('WildMenu', 'bg', 'Mantis', 'gui=bold')
else
    call s:hilite('Normal', 'EgyptianBlue', 'Beige')
    call s:hilite('Comment', 'GreyGreen', 'NONE')
    call s:hilite('Constant', 'Cocoa', 'NONE')
    call s:hilite('CursorLine', 'NONE', 'Grey85', 'NONE')
    call s:hilite('Error', 'fg', 'Cocoa')
    call s:hilite('TabLine', 'NONE', 'Aquamarine', 'NONE')
    call s:hilite('Underlined', 'fg', 'Aquamarine', 'underline')
    call s:hilite('WildMenu', 'NONE', 'Aquamarine')
endif

call s:hilite('StatusLine', 'NONE', 'NONE', 'bold,reverse')
call s:hilite('StatusLineNC', 'NONE', 'NONE', 'reverse')
call s:hilite('TabLineSel', 'fg', 'bg', 'bold')
call s:hilite('Visual', 'bg', 'fg', 'NONE')

call s:hilink('Normal', 'CursorLineNr', 'Function', 'Identifier', 'ModeMsg', 'PreProc',
    \ 'Statement', 'Type')
call s:hilink('Comment', 'FoldColumn', 'Folded', 'LineNr', 'NonText', 'SignColumn',
    \ 'SpecialKey')
call s:hilink('Constant', 'Directory', 'helpHyperTextEntry', 'helpHyperTextJump',
    \ 'helpOption', 'MoreMsg', 'Question', 'Special', 'Title')
call s:hilink('Error', 'DiffDelete', 'ErrorMsg', 'MatchParen', 'PmenuThumb',
    \ 'WarningMsg')
call s:hilink('CursorLine', 'CursorColumn')
call s:hilink('StatusLine', 'StatusLineTerm', 'ToolbarButton')
call s:hilink('StatusLineNC', 'ColorColumn', 'Cursor', 'DiffChange', 'lCursor',
    \ 'Search', 'StatusLineTermNC')
call s:hilink('TabLine', 'ToolbarLine')
call s:hilink('Underlined', 'SpellBad', 'SpellCap', 'SpellLocal', 'SpellRare',
    \ 'VisualNOS')
call s:hilink('Visual', 'helpNote', 'Pmenu', 'PmenuSbar', 'TabLineFill', 'VertSplit')
call s:hilink('WildMenu', 'DiffAdd', 'DiffText', 'IncSearch', 'PmenuSel', 'Todo')
