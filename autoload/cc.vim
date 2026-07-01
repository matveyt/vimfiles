" This is a part of my Vim configuration
" https://github.com/matveyt/vimfiles

let s:ccinfo = #{
    \   gcc: #{
    \       cross: { arch -> arch .. '-gcc' },
    \       opts: '-xc++ -v -E -',
    \       begin: '^#include <\.\.\.>',
    \       end: '\.$',
    \   },
    \   sdcc: #{
    \       cross: { arch -> 'sdcc -m' .. arch },
    \       opts: '--print-search-dirs',
    \       begin: '^include',
    \       end: '^lib',
    \   },
    \   tcc: #{
    \       cross: { -> 'tcc' },
    \       opts: '-vv',
    \       begin: '^include',
    \       end: '^lib',
    \   },
    \ }

"
function! cc#arch() abort
    return ['native', 'arm-none-eabi', 'avr', 'mcs51', 'msp430', 'riscv-none-elf',
        \ 'stm8']
endfunction

" cc#compilers()
" get compilers List
function! cc#compilers() abort
    return s:ccinfo->keys()->sort()
endfunction

" cc#include({cc} [, {arch} [, {force}]])
" get CC include dirs
function! cc#include(cc, arch=get(g:, 'target_arch', 'native'), force=v:false) abort
    let l:var = fnamemodify(a:cc .. '_include_' .. a:arch, ':gs?[-.]?_?')
    if a:force || !has_key(s:, l:var)
        " $CPATH
        let s:[l:var] = split($CPATH, has('win32') ? ';' : ':')
        " builtin dirs
        let l:cross_cc = a:arch is# 'native' ? a:cc : s:ccinfo[a:cc].cross(a:arch)
        let l:cmd = join([l:cross_cc, s:ccinfo[a:cc].opts])
        let l:include = map(systemlist(l:cmd, []), 'trim(v:val)')
        let l:ix1 = match(l:include, s:ccinfo[a:cc].begin) + 1
        let l:ix2 = match(l:include, s:ccinfo[a:cc].end, l:ix1) - 1
        if l:ix1 <= l:ix2
            let s:[l:var] += map(l:include[l:ix1 : l:ix2], 'simplify(v:val)')
        endif
    endif
    return copy(s:[l:var])
endfunction
