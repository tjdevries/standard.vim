""
" Get the directory
" @param[optional] Full path
function! std#git#root(...) abort
  let path = expand('%:p:h')
  if a:0 > 0
    let path = a:1
  endif

  let found = v:false
  while len(path) > 0
    if isdirectory(path . '/.git')
      return path . std#path#separator()
    endif

    let path = fnamemodify(path, ':h')
    echo path
  endwhile

  return ''
endfunction

