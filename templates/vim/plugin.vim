" Vim plugin
" Last Change:  %{strftime('%Y %b %d')}
" License:      VIM License
" URL:          https://github.com/matveyt/vim-%{fnamemodify(@%, ':t:r')}

if exists('g:loaded_%{fnamemodify(@%, ':t:r')}')
    finish
endif
let g:loaded_%{fnamemodify(@%, ':t:r')} = 1

let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo
