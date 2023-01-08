" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if has('nvim')
    packadd! neoclip
else
    packadd! matchit
    source $VIMRUNTIME/ftplugin/man.vim
endif

let s:pack = {}
let s:pack.manager = 'minpac'
let s:pack.author = 'k-takata'
let s:pack.progress_open = 'vertical'

command! -bar PackClean  call metapack#init(s:pack).clean()
command! -bar PackStatus call metapack#init(s:pack).status()
command! -bar PackUpdate call metapack#init(s:pack).update()

function s:pack.init() abort
    " plugins
    call self.add('romainl/Apprentice', #{type: 'opt'})
    call self.add('scheakur/vim-scheakur', #{type: 'opt', frozen: 1})
    call self.add('wellle/targets.vim', #{frozen: 1})
    call self.add('mbbill/undotree')
    call self.add('chrisbra/unicode.vim', #{type: 'opt'})

    " my plugins can be under ~/.vim/pack/manual
    if better#stdpath('config', 'pack/manual')->isdirectory()
        return
    endif

    " my plugins
    call self.add('matveyt/neoclip', #{type: 'opt'})
    call self.add('matveyt/vim-drvo')
    call self.add('matveyt/vim-filters', #{type: 'opt'})
    call self.add('matveyt/vim-guidedspace')
    call self.add('matveyt/vim-intl')
    call self.add('matveyt/vim-jmake', #{type: 'opt'})
    call self.add('matveyt/vim-qmake', #{type: 'opt'})
    call self.add('matveyt/vim-modest', #{type: 'opt'})
    call self.add('matveyt/vim-moveit', #{type: 'opt'})
    call self.add('matveyt/vim-opera')
    call self.add('matveyt/vim-ranger', #{type: 'opt'})
    call self.add('matveyt/vim-scratch')
    call self.add('matveyt/vim-stalin')
endfunction
