" This is a part of my vim configuration.
" https://github.com/matveyt/vimfiles

let s:meta = {}

function s:meta.byname() abort
    " foo-bar.baz => bar
    let l:dot = stridx(self.name, '.')
    let l:name = l:dot < 0 ? self.name : strpart(self.name, 0, l:dot)
    return strpart(l:name, strridx(l:name, '-') + 1)
endfunction

function s:meta.call(func, ...) abort
    try
        return printf('%s#%s', self.byname(), a:func)->call(a:000)
    catch | endtry
endfunction
let s:meta.add = funcref('s:meta.call', ['add'])

function s:meta.init() abort
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
    call self.call('begin')
    call self.call('init', #{depth: 1, progress_open: 'vertical'})

    " register plugins
    call self.add(l:remote, #{type: 'opt'})
    call self.plug()

    call self.call('end')
endfunction

function! metapack#init(pack) abort
    " one time init
    if !has_key(a:pack, 'init')
        call extend(a:pack, s:meta).init()
    endif

    return a:pack
endfunction
