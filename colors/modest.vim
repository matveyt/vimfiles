" Vim color file
" Maintainer:   matveyt
" Last Change:  2019 Jun 21
" URL:          https://github.com/matveyt/vimfiles/colors

set bg=dark
hi clear
if exists('g:syntax_on')
    syntax reset
endif

let g:colors_name = 'modest'

let s:palette = {}
let s:palette.Eigengrau = ['Black', 234, '#16161d']
let s:palette.GreyGreen = ['DarkGrey', 242, '#5e716a']
let s:palette.AshGrey = ['LightGrey', 250, '#b2beb5']
let s:palette.Mantis = ['DarkGreen', 77, '#74c365']
let s:palette.Sienna = ['Brown', 130, '#882d17']

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
    let l:ctermfg = 'ctermfg=' . get(l:fg, &t_Co==256, l:fg[0])
    let l:ctermbg = 'ctermbg=' . get(l:bg, &t_Co==256, l:bg[0])
    let l:guifg = 'guifg=' . get(l:fg, 2, l:fg[0])
    let l:guibg = 'guibg=' . get(l:bg, 2, l:bg[0])
    execute 'hi' a:group l:term l:ctermfg l:ctermbg l:guifg l:guibg
endfunction

function! s:hilink(to_group, ...)
    for l:from_group in a:000
        execute 'hi! link' l:from_group a:to_group
    endfor
endfunction

call s:hilite('Normal', 'AshGrey', 'Eigengrau')
call s:hilite('Comment', 'GreyGreen', 'NONE')
call s:hilite('Constant', 'Mantis', 'NONE')
call s:hilite('Error', 'NONE', 'Sienna')
call s:hilite('StatusLine', 'NONE', 'NONE', 'bold,reverse')
call s:hilite('StatusLineNC', 'NONE', 'NONE', 'reverse')
call s:hilite('TabLine', 'NONE', 'GreyGreen', 'underline')
call s:hilite('TabLineSel', 'NONE', 'NONE', 'bold')
call s:hilite('Underlined', 'fg', 'Sienna', 'underline')
call s:hilite('Visual', 'bg', 'fg', 'NONE')
call s:hilite('WildMenu', 'bg', 'Mantis', 'gui=bold')

call s:hilink('Normal', 'CursorColumn', 'CursorLine', 'CursorLineNr', 'Function',
    \ 'Identifier', 'ModeMsg', 'PreProc', 'Statement', 'Type')
call s:hilink('Comment', 'Conceal', 'FoldColumn', 'Folded', 'LineNr', 'NonText',
    \ 'SignColumn', 'SpecialKey')
call s:hilink('Constant', 'Directory', 'helpHyperTextEntry', 'helpHyperTextJump',
    \ 'helpOption', 'MoreMsg', 'Question', 'Special', 'Title')
call s:hilink('Error', 'DiffDelete', 'ErrorMsg', 'MatchParen', 'PmenuThumb',
    \ 'WarningMsg')
call s:hilink('StatusLine', 'StatusLineTerm', 'ToolbarButton')
call s:hilink('StatusLineNC', 'ColorColumn', 'Cursor', 'DiffChange', 'lCursor',
    \ 'Search', 'StatusLineTermNC')
call s:hilink('TabLine', 'ToolbarLine')
call s:hilink('Underlined', 'SpellBad', 'SpellCap', 'SpellLocal', 'SpellRare',
    \ 'VisualNOS')
call s:hilink('Visual', 'helpNote', 'Pmenu', 'PmenuSbar', 'TabLineFill', 'VertSplit')
call s:hilink('WildMenu', 'DiffAdd', 'DiffText', 'IncSearch', 'PmenuSel', 'Todo')
