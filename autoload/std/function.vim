""
" Get the list of arguments from a function name
function! std#function#arguments(func_name) abort
  let func_string = execute('function /^' . a:func_name . '$')

  if len(func_string) < 2
    return []
  endif

  let left_parenth = stridx(func_string, '(')
  let right_parenth = strridx(func_string, ')')

  let args = split(func_string[left_parenth + 1:right_parenth - 1], ', ')

  return args
endfunction
