" Vim color file
"
" This is a very minimalistic color scheme for both terminal and GUI

set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "modest"

hi Normal ctermbg=Black ctermfg=Grey guibg=#101010 guifg=#d0d0d0
hi Constant ctermfg=Green guifg=#60d060
hi NonText ctermfg=DarkGrey guifg=#607060 gui=NONE
hi ColorColumn ctermbg=Grey guibg=#607060
hi Visual guibg=#607060
hi! link CursorLine Normal
hi! link CursorLineNr Normal
hi! link Folded Normal
hi! link Function Normal
hi! link Identifier Normal
hi! link PreProc Normal
hi! link Special Normal
hi! link Statement Normal
hi! link Type Normal
hi! link Directory Constant
hi! link MoreMsg Constant
hi! link SpecialKey Constant
hi! link Title Constant
hi! link Comment NonText
hi! link FoldColumn NonText
hi! link LineNr NonText
hi! link SignColumn NonText
