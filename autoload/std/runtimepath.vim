""
" See if a string is contained in the runtime path
function! std#runtimepath#contains(substring) abort
  return len(filter(
        \ split(&runtimepath, ','),
        \ {idx, value -> std#string#contains(value, a:substring)}
        \ )) > 0
endfunction
