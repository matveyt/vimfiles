" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

if has('nvim')
    packadd! neoclip
else
    packadd! matchit
    source $VIMRUNTIME/ftplugin/man.vim
endif

" disable standard plugins
call better#defaults(#{getscriptPlugin: 0, gzip: 0, logiPat: 0, netrwPlugin: 0,
    \ spellfile_plugin: 0, tarPlugin: 0, vimballPlugin: 0, zipPlugin: 0,
    \ 2html_plugin: 0}, 'loaded')
call better#defaults(has('nvim') ? #{node_provider: 0, perl_provider: 0,
    \ python_provider: 0, python3_provider: 0, ruby_provider: 0, remote_plugins: 0,
    \ shada_plugin: 0, tutor_mode_plugin: 0} : #{rrhelper: 0}, 'loaded')

command! -bar PackClean  call s:pack.init() | call s:pack.call('clean')
command! -bar PackStatus call s:pack.init() | call s:pack.call('status')
command! -bar PackUpdate call s:pack.init() | call s:pack.call('update')

" package manager
let s:pack = #{site: 'https://github.com',
    \ name: 'minpac', author: 'k-takata',
    "\ name: 'vim-packager', author: 'kristijanhusak',
    \ }

function s:pack.byname() abort
    " foo-bar-baz => baz
    return strpart(self.name, strridx(self.name, '-') + 1)
endfunction

function s:pack.call(func, ...) abort
    return printf('%s#%s', self.byname(), a:func)->call(a:000)
endfunction
let s:pack.add = funcref('s:pack.call', ['add'])

function s:pack.init() abort
    if exists('g:loaded_'..tr(self.name, '-', '_'))
        return
    endif

    " git-clone package manager
    let l:local = better#stdpath('config', 'pack/%s/opt/%s', self.byname(), self.name)
    let l:remote = printf('%s/%s/%s', self.site, self.author, self.name)
    if !isdirectory(l:local)
        echomsg 'Cloning into' l:local
        silent call system(printf('git clone --depth=1 %s.git %s', l:remote,
            \ shellescape(l:local)))
    endif

    " initialize package manager
    execute 'packadd' self.name
    call self.call('init', #{depth: 1, progress_open: 'vertical'})
    call self.add(l:remote, #{type: 'opt'})

    " plugins
    call self.add('tpope/vim-surround')
    call self.add('wellle/targets.vim')
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

    " my own plugins could sit under ~/.vim/pack/manual
    if !better#stdpath('config', 'pack/manual')->isdirectory()
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
    endif
endfunction
