""
" contains an item
function! std#list#contains(l, val) abort
  return index(a:l, a:val) != -1
endfunction
