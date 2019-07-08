" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
" color schemes
call minpac#add('romainl/flattened')
call minpac#add('w0ng/vim-hybrid', {'frozen': 1})
call minpac#add('haishanh/night-owl.vim')
call minpac#add('jacoborus/tender.vim')
" other stuff
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('justinmk/vim-dirvish')
call minpac#add('Yggdroot/indentLine')
call minpac#add('vim-latex/vim-latex')
call minpac#add('mhinz/vim-signify')
call minpac#add('majutsushi/tagbar')
call minpac#add('mbbill/undotree')

command! PackClean call minpac#clean()
command! PackStatus call minpac#status()
command! PackUpdate call minpac#update()

" plugin specific variables
let g:c_gnu = 1
let g:c_no_curly_error = 1
let g:loaded_netrwPlugin = 0
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:dirvish_mode = ':sort i /^.*\//'
let g:signify_vcs_list = ['git']
let g:signify_disable_by_default = 1
let g:undotree_WindowLayout = 4

" needed to have auto-download working (e.g. spell files)
" note: taken from netrwPlugin
command! -count=1 -nargs=* Nread
    \ let s:svpos=winsaveview() |
    \ call netrw#NetRead(<count>,<f-args>) |
    \ call winrestview(s:svpos)

" some utility mappings for plugins
autocmd vimrc FileType dirvish nmap <buffer><BS> <Plug>(dirvish_up)
nmap <kMinus> <Plug>(dirvish_up)
nnoremap <Leader>s :SignifyToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>u :UndotreeToggle<CR>
