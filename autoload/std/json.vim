""
" Format JSON prettily
" Returns a list of the formatted JSON
" You can use nvim_buf_set_lines to print this, or writefile would work as
" well
function! std#json#format(json_argument) abort
  let temp_file = tempname()

  let file_contents = []
  if type(a:json_argument) == v:t_string
    let file_contents = [a:json_argument]
  elseif type(a:json_argument) == v:t_list
    let file_contents = a:json_argument
  else
    return '[STD.JSON] String or List requied. Got: ' . string(a:json_argument)
  endif

  if writefile(file_contents, temp_file) == -1
    return '[STD.JSON] ERROR'
  endif

  if !executable('python')
    return '[STD.JSON] Python executable is required'
  endif

  return split(system(['python', '-m', 'json.tool', temp_file]), "\n")
endfunction

""
" Encode a vim object as well as we can,
" try not to fail, even if we have functions,etc.
function! std#json#encode(vim_obj) abort
  
endfunction
