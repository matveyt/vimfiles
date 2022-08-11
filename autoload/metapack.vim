" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

function! metapack#init(pack) abort
    " one time init
    if !has_key(a:pack, 'init')
        call extend(a:pack, s:meta).init()
    endif

    return a:pack
endfunction

let s:meta = #{
    \ git: 'git clone --depth=1',
    \ site: 'https://github.com',
    \ author: 'k-takata',
    \ manager: 'minpac',
    \ }

function s:meta.init() abort
    " git-clone package manager
    let l:local = better#stdpath('config', 'pack/%s/opt/%s', self.byname(), self.manager)
    let l:remote = printf('%s/%s/%s', self.site, self.author, self.manager)
    if !isdirectory(l:local)
        echomsg 'Cloning into' l:local
        call system(printf('%s %s.git %s', self.git, l:remote, shellescape(l:local)))
    endif

    " initialize package manager
    execute 'packadd' self.manager
    call self.call('begin')
    call self.call('init', #{depth: 1, progress_open: 'vertical'})

    " register plugins
    call self.add(l:remote, #{type: 'opt'})
    if has_key(self, 'plug')
        call self.plug()
    endif

    call self.call('end')
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
