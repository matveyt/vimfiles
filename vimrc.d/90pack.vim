" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if has('nvim')
    packadd! neoclip
else
    packadd! matchit
    source $VIMRUNTIME/ftplugin/man.vim
endif

" disable standard plugins
call better#defaults('loaded', #{getscriptPlugin: 0, gzip: 0, logiPat: 0, netrwPlugin: 0,
    \ spellfile_plugin: 0, tarPlugin: 0, vimballPlugin: 0, zipPlugin: 0,
    \ 2html_plugin: 0})
call better#defaults('loaded', has('nvim') ? #{node_provider: 0, perl_provider: 0,
    \ python_provider: 0, python3_provider: 0, ruby_provider: 0, remote_plugins: 0,
    \ shada_plugin: 0, tutor_mode_plugin: 0} : #{rrhelper: 0})

" package manager setup
let s:pack = {'site': 'https://github.com',
    \ 'name': 'minpac', 'author': 'k-takata',
    "\ 'name': 'vim-packager', 'author': 'kristijanhusak',
    \ }

command! -bar PackClean  call s:pack_setup() | call s:pack_call('clean')
command! -bar PackStatus call s:pack_setup() | call s:pack_call('status')
command! -bar PackUpdate call s:pack_setup() | call s:pack_call('update')

function s:pack_byname() abort
    " foo-bar-baz => baz
    return strpart(s:pack.name, strridx(s:pack.name, '-') + 1)
endfunction

function s:pack_call(func, ...) abort
    return call(printf('%s#%s', s:pack_byname(), a:func), a:000)
endfunction
let s:pack_add = funcref('s:pack_call', ['add'])

function s:pack_setup() abort
    if exists('g:loaded_' . tr(s:pack.name, '-', '_'))
        return
    endif

    " git-clone package manager
    let l:local = better#stdpath('config', 'pack/%s/opt/%s', s:pack_byname(),
        \ s:pack.name)
    let l:remote = printf('%s/%s/%s', s:pack.site, s:pack.author, s:pack.name)
    if !isdirectory(l:local)
        echomsg 'Cloning into' l:local
        silent call system(printf('git clone --depth=1 %s.git %s',
            \ l:remote, shellescape(l:local)))
    endif

    " initialize package manager
    execute 'packadd' s:pack.name
    call s:pack_call('init', {'depth': 1, 'progress_open': 'vertical'})
    call s:pack_add(l:remote, {'type': 'opt'})

    " plugins
    call s:pack_add('tpope/vim-surround')
    call s:pack_add('wellle/targets.vim')
    call s:pack_add('mbbill/undotree')
    call s:pack_add('chrisbra/unicode.vim', {'type': 'opt'})

    " color schemes
    call s:pack_add('w0ng/vim-hybrid', {'type': 'opt', 'frozen': 1})
    call s:pack_add('vim-scripts/Liquid-Carbon', {'type': 'opt', 'frozen': 1})
    call s:pack_add('KeitaNakamura/neodark.vim', {'type': 'opt'})
    call s:pack_add('haishanh/night-owl.vim', {'type': 'opt'})
    call s:pack_add('scheakur/vim-scheakur', {'type': 'opt', 'frozen': 1})
    call s:pack_add('nightsense/snow', {'type': 'opt', 'frozen': 1})
    call s:pack_add('nightsense/stellarized', {'type': 'opt', 'frozen': 1})

    " my own plugins could sit under ~/.vim/pack/manual
    if !isdirectory(better#stdpath('config', 'pack/manual'))
        call s:pack_add('matveyt/neoclip', {'type': 'opt'})
        call s:pack_add('matveyt/vim-drvo')
        call s:pack_add('matveyt/vim-filters')
        call s:pack_add('matveyt/vim-guidedspace')
        call s:pack_add('matveyt/vim-jmake')
        call s:pack_add('matveyt/vim-qmake', {'type': 'opt'})
        call s:pack_add('matveyt/vim-modest', {'type': 'opt'})
        call s:pack_add('matveyt/vim-moveit', {'type': 'opt'})
        call s:pack_add('matveyt/vim-opera')
        call s:pack_add('matveyt/vim-ranger', {'type': 'opt'})
        call s:pack_add('matveyt/vim-scratch')
        call s:pack_add('matveyt/vim-stalin')
    endif
endfunction
