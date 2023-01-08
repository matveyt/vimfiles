" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

let s:meta = #{
    \ git: 'git',
    \ depth: 1,
    \ dir: better#stdpath('config'),
    \ site: 'https://github.com',
    \ author: 'k-takata',
    \ manager: 'minpac'
    \ }

function! metapack#init(pack) abort
    " one time init
    if !has_key(a:pack, 'call')
        call extend(a:pack, s:meta, 'keep')

        " git-clone package manager
        let l:local = printf('%s/pack/%s/opt/%s', a:pack.dir, a:pack.byname(),
            \ a:pack.manager)
        let l:remote = printf('%s/%s/%s', a:pack.site, a:pack.author, a:pack.manager)
        if !isdirectory(l:local)
            echomsg 'Cloning into' l:local
            call printf('%s clone --depth=%d %s.git %s', a:pack.git, a:pack.depth,
                \ l:remote, l:local->shellescape())->system()
        endif

        " initialize package manager
        execute 'packadd' a:pack.manager
        call a:pack.call('begin')
        call a:pack.call('init', a:pack)

        " register plugins
        call a:pack.add(l:remote, #{type: 'opt'})
        call a:pack.init()

        call a:pack.call('end')
    endif

    return a:pack
endfunction

function s:meta.byname() abort
    " foo-bar.baz => bar
    let l:dot = stridx(self.manager, '.')
    let l:name = l:dot < 0 ? self.manager : strpart(self.manager, 0, l:dot)
    return strpart(l:name, strridx(l:name, '-') + 1)
endfunction

function s:meta.call(func, ...) abort
    try
        return printf('%s#%s', self.byname(), a:func)->call(a:000)
    catch | endtry
endfunction

let s:meta.add = funcref('s:meta.call', ['add'])
let s:meta.clean = funcref('s:meta.call', ['clean'])
let s:meta.status = funcref('s:meta.call', ['status'])
let s:meta.update = funcref('s:meta.call', ['update'])
