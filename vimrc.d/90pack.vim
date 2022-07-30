" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if has('nvim')
    packadd! neoclip
else
    packadd! matchit
    source $VIMRUNTIME/ftplugin/man.vim
endif

command! -bar PackClean  call metapack#init(s:pack).call('clean')
command! -bar PackStatus call metapack#init(s:pack).call('status')
command! -bar PackUpdate call metapack#init(s:pack).call('update')

" package manager
let s:pack = #{
    \ site: 'https://github.com',
    \ name: 'minpac', author: 'k-takata',
    "\ name: 'vim-packager', author: 'kristijanhusak',
    \ }

function s:pack.plug() abort
    " plugins
    call self.add('wellle/targets.vim', #{frozen: 1})
    call self.add('mbbill/undotree')
    call self.add('chrisbra/unicode.vim', #{type: 'opt'})

    " color schemes
    call self.add('w0ng/vim-hybrid', #{type: 'opt', frozen: 1})
    call self.add('vim-scripts/Liquid-Carbon', #{type: 'opt', frozen: 1})
    call self.add('KeitaNakamura/neodark.vim', #{type: 'opt'})
    call self.add('haishanh/night-owl.vim', #{type: 'opt'})
    call self.add('scheakur/vim-scheakur', #{type: 'opt', frozen: 1})
    call self.add('nightsense/snow', #{type: 'opt', frozen: 1})
    call self.add('nightsense/stellarized', #{type: 'opt', frozen: 1})

    " my plugins can be under ~/.vim/pack/manual
    if better#stdpath('config', 'pack/manual')->isdirectory()
        return
    endif

    " my plugins
    call self.add('matveyt/neoclip', #{type: 'opt'})
    call self.add('matveyt/vim-drvo')
    call self.add('matveyt/vim-filters')
    call self.add('matveyt/vim-guidedspace')
    call self.add('matveyt/vim-intl')
    call self.add('matveyt/vim-jmake')
    call self.add('matveyt/vim-qmake', #{type: 'opt'})
    call self.add('matveyt/vim-modest', #{type: 'opt'})
    call self.add('matveyt/vim-moveit', #{type: 'opt'})
    call self.add('matveyt/vim-opera')
    call self.add('matveyt/vim-ranger', #{type: 'opt'})
    call self.add('matveyt/vim-scratch')
    call self.add('matveyt/vim-stalin')
endfunction
