" impaired.vim - trimmed down version of unimpaired.vim
" Author: Ian Emnace <igemnace@gmail.com>

" Original work is attributed as follows:
" unimpaired.vim: https://github.com/tpope/vim-unimpaired
" Copyright (c) Tim Pope. Distributed under the same terms as Vim itself. See
" `:help license`.

" This file is expressly distributed with the Vim license (`:help license`).

" Quickfix motions {{{1
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>
" }}}

" SCM conflict motions {{{1
nnoremap <silent> [n :call <SID>Context(1)<CR>
nnoremap <silent> ]n :call <SID>Context(0)<CR>
onoremap <silent> [n :call <SID>ContextMotion(1)<CR>
onoremap <silent> ]n :call <SID>ContextMotion(0)<CR>

function! s:Context(reverse)
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

function! s:ContextMotion(reverse)
  if a:reverse
    -
  endif
  call search('^@@ .* @@\|^diff \|^[<=>|]\{7}[<=>|]\@!', 'bWc')
  if getline('.') =~# '^diff '
    let end = search('^diff ', 'Wn') - 1
    if end < 0
      let end = line('$')
    endif
  elseif getline('.') =~# '^@@ '
    let end = search('^@@ .* @@\|^diff ', 'Wn') - 1
    if end < 0
      let end = line('$')
    endif
  elseif getline('.') =~# '^=\{7\}'
    +
    let end = search('^>\{7}>\@!', 'Wnc')
  elseif getline('.') =~# '^[<=>|]\{7\}'
    let end = search('^[<=>|]\{7}[<=>|]\@!', 'Wn') - 1
  else
    return
  endif
  if end > line('.')
    execute 'normal! V'.(end - line('.')).'j'
  elseif end == line('.')
    normal! V
  endif
endfunction
" }}}

" Option toggling {{{1
function! s:statusbump() abort
  let &l:readonly = &l:readonly
  return ''
endfunction

function! s:toggle(op) abort
  call s:statusbump()
  return eval('&'.a:op) ? 'no'.a:op : a:op
endfunction

nnoremap =ol :setlocal <C-r>=<SID>toggle('list')<CR><CR>
nnoremap =oc :setlocal <C-r>=<SID>toggle('cursorcolumn')<CR><CR>
nnoremap =os :setlocal <C-r>=<SID>toggle('spell')<CR><CR>
nnoremap =ow :setlocal <C-r>=<SID>toggle('wrap')<CR><CR>
" }}}

" Put mappings {{{1
function! s:putline(how) abort
  let [body, type] = [getreg(v:register), getregtype(v:register)]
  if type ==# 'V'
    exe 'normal! "'.v:register.a:how
  else
    call setreg(v:register, body, 'l')
    exe 'normal! "'.v:register.a:how
    call setreg(v:register, body, type)
  endif
endfunction

nnoremap [p :call <SID>putline('[p')<CR>
nnoremap ]p :call <SID>putline(']p')<CR>
nmap =P [p=']
nmap =p ]p=']
" }}}

" vim:fdm=marker
