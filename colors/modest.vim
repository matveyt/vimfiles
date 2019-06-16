" Vim color file
" Maintainer:   matveyt
" Last Change:  2019 Jun 16
" URL:          https://github.com/matveyt/vimfiles/colors

set bg=dark
hi clear
if exists('g:syntax_on')
    syntax reset
endif

let g:colors_name = 'modest'

let s:palette = {'bg': 'bg', 'fg': 'fg', 'NONE': 'NONE'}
let s:palette.Black     = '#16161d' " Eigengrau
let s:palette.DarkGrey  = '#5e716a' " Grey-green
let s:palette.Green     = '#74c365' " Mantis
let s:palette.LightGrey = '#b2beb5' " Ash grey

function! s:hilite(group, fg, bg, ...)
    let l:cterm = a:0 ? 'cterm=' . (a:1[0] ? 'bold' : 'NONE') : ''
    let l:ctermfg = 'ctermfg=' . a:fg
    let l:ctermbg = 'ctermbg=' . a:bg
    let l:gui = a:0 ? 'gui=' . (a:1[1] ? 'bold' : 'NONE') : ''
    let l:guifg = 'guifg=' . s:palette[a:fg]
    let l:guibg = 'guibg=' . s:palette[a:bg]
    execute 'hi' a:group l:cterm l:ctermfg l:ctermbg l:gui l:guifg l:guibg
endfunction

function! s:hilink(to_group, ...)
    for l:from_group in a:000
        execute 'hi! link' l:from_group a:to_group
    endfor
endfunction

call s:hilite('Normal', 'LightGrey', 'Black')
call s:hilite('Constant', 'Green', 'NONE')
call s:hilite('Comment', 'DarkGrey', 'NONE', [&t_Co == 8, 0])
call s:hilite('IncSearch', 'bg', 'Green', [0, 1])
call s:hilite('Search', 'bg', 'fg', [0, 0])
call s:hilite('StatusLine', 'bg', 'fg', [0, 1])

call s:hilink('Normal', 'CursorColumn', 'CursorLine', 'CursorLineNr', 'Folded',
    \ 'Function', 'Identifier', 'ModeMsg', 'PreProc', 'Statement', 'Type')
call s:hilink('Constant', 'Directory', 'helpHyperTextEntry', 'helpHyperTextJump',
    \ 'helpOption', 'MoreMsg', 'Question', 'Special', 'Title')
call s:hilink('Comment', 'FoldColumn', 'LineNr', 'NonText', 'SignColumn', 'SpecialKey')
call s:hilink('IncSearch', 'DiffAdd', 'DiffText', 'PmenuSel', 'Todo', 'WildMenu')
call s:hilink('Search', 'DiffChange', 'MatchParen', 'Pmenu', 'StatusLineNC',
    \ 'StatusLineTermNC', 'Visual')
call s:hilink('StatusLine', 'ColorColumn', 'DiffDelete', 'helpNote', 'StatusLineTerm',
    \ 'VertSplit')
