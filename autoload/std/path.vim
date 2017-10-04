""
" Path separator
function! std#path#separator() abort
  if std#os#has_windows()
    return '\'
  else
    return '/'
  endif
endfunction
