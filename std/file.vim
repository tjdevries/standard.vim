""
" Return a standard, unix slashed file name
function! std#file#name(file_name) abort
  let result_name = copy(a:file_name)

  " I like UNIX lines :)
  let result_name = substitute(result_name, '\\', '/', 'g')

  " All substitutions
  let result_name = substitute(result_name, $HOME, '~', '')

  " Replace double slashes with one
  let result_name = substitute(result_name, '//', '/', 'g')

  return result_name
endfunction
