" Vim color file
" Maintainer:   matveyt
" Last Change:  2019 Jun 18
" URL:          https://github.com/matveyt/vimfiles/colors

set bg=dark
hi clear
if exists('g:syntax_on')
    syntax reset
endif

let g:colors_name = 'modest'

let s:palette = {'fg': 'fg', 'bg': 'bg', 'NONE': 'NONE'}
let s:palette.Black     = '#16161d' " Eigengrau
let s:palette.DarkGrey  = '#5e716a' " Grey-green
let s:palette.LightGrey = '#b2beb5' " Ash grey
let s:palette.DarkGreen = '#74c365' " Mantis
let s:palette.Brown     = '#882d17' " Sienna

function! s:hilite(group, fg, bg, ...)
    if !a:0
        let l:term = ''
    elseif stridx(a:1, '=') != -1
        let l:term = a:1
    else
        let l:term = 'term=' . a:1 . ' cterm=' . a:1 . ' gui=' . a:1
    endif
    let l:ctermfg = 'ctermfg=' . a:fg
    let l:ctermbg = 'ctermbg=' . a:bg
    let l:guifg = 'guifg=' . s:palette[a:fg]
    let l:guibg = 'guibg=' . s:palette[a:bg]
    execute 'hi' a:group l:term l:ctermfg l:ctermbg l:guifg l:guibg
endfunction

function! s:hilink(to_group, ...)
    for l:from_group in a:000
        execute 'hi! link' l:from_group a:to_group
    endfor
endfunction

call s:hilite('Normal', 'LightGrey', 'Black')
call s:hilite('Comment', 'DarkGrey', 'NONE')
call s:hilite('Constant', 'DarkGreen', 'NONE')
call s:hilite('Bold', 'NONE', 'NONE', 'bold')
call s:hilite('Reverse', 'NONE', 'NONE', 'reverse')
call s:hilite('Standout', 'NONE', 'NONE', 'bold,reverse')
call s:hilite('Visual', 'bg', 'fg', 'NONE')
call s:hilite('Standout1', 'bg', 'DarkGreen', 'gui=bold')
call s:hilite('Standout2', 'NONE', 'Brown')
call s:hilite('Underline1', 'fg', 'Brown', 'underline')
call s:hilite('Underline2', 'NONE', 'DarkGrey', 'underline')

call s:hilink('Normal', 'CursorColumn', 'CursorLine', 'CursorLineNr', 'Folded',
    \ 'Function', 'Identifier', 'ModeMsg', 'PreProc', 'Statement', 'Type')
call s:hilink('Comment', 'Conceal', 'FoldColumn', 'LineNr', 'MatchParen', 'NonText',
    \'SignColumn', 'SpecialKey')
call s:hilink('Constant', 'Directory', 'helpHyperTextEntry', 'helpHyperTextJump',
    \ 'helpOption', 'MoreMsg', 'Question', 'Special', 'Title')
call s:hilink('Bold', 'TabLineSel')
call s:hilink('Reverse', 'ColorColumn', 'Cursor', 'DiffChange', 'lCursor', 'Pmenu',
    \ 'PmenuSbar', 'Search', 'StatusLineNC', 'StatusLineTermNC', 'TabLineFill',
    \ 'VertSplit')
call s:hilink('Standout', 'helpNote', 'StatusLine', 'StatusLineTerm', 'ToolbarButton')
call s:hilink('Standout1', 'IncSearch', 'DiffAdd', 'DiffText', 'PmenuSel', 'Todo',
    \ 'WildMenu')
call s:hilink('Standout2', 'DiffDelete', 'Error', 'ErrorMsg', 'PMenuThumb',
    \ 'WarningMsg')
call s:hilink('Underline1', 'SpellBad', 'SpellCap', 'SpellLocal', 'SpellRare',
    \ 'Underlined', 'VisualNOS')
call s:hilink('Underline2', 'TabLine', 'ToolbarLine')
