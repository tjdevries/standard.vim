function! std#string#byte(s, i) abort
  return luaeval('string.byte(_A.s, _A.i)', {'s': a:s, 'i': (a:i + 1)})
endfunction

function! std#string#upper(s) abort
  return luaeval('string.upper(_A)', a:s)
endfunction

function! std#string#contains(s, sub) abort
  return stridx(a:s, a:sub) >= 0
endfunction

""
" Take {var} and a dict and return the values
" TODO: Write some tests for this
" TODO: Performance test this :)
function! std#string#interpolate(s, d) abort
  let context = copy(a:d)

  let old_string = ''
  let current_string = a:s

  " This is mostly helpful with large dictionaries.
  " We do a lot less matches with these items removed
  for key in keys(context)
    if stridx(current_string, key) < 0
      call remove(context, key)
    endif
  endfor

  " Now do the replacements
  while current_string !=# old_string
    let old_string = current_string

    for key in keys(context)
      let current_string = substitute(
            \ current_string,
            \ '{' . key . '\%[:]\([^{}]*\)}',
            \ { modifier_list ->
              \ printf('%' .
                \ (len(modifier_list) > 1 && modifier_list[1] != '' ? modifier_list[1] : "s")
                \ , context[key])},
            \ 'g')
    endfor
  endwhile

  return current_string
endfunction
