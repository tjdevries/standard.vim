""
" Path separator
function! std#path#separator() abort
  if !has('unix')
    return '\'
  else
    return '/'
  endif
endfunction
