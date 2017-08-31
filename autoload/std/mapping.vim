""
" Send the original global mapping, if it exists.
" Otherwise just send the actual item itself.
" This lets you add buffer overrides for things, but still send the original
" global one if you want!
function! std#mapping#execute_global(mode, mapping) abort
  let map_list = nvim_get_keymap(a:mode)
  call filter(map_list, { idx, val -> val.lhs == a:mapping})

  if len(map_list) != 1
    return nvim_replace_termcodes(a:mapping, v:true, v:false, v:true)
  endif

  let map_dict = map_list[0]

  return std#mapping#execute_dict(map_dict)
endfunction

function! std#mapping#execute_dict(dict) abort
  if map_dict.expr
    return execute(map_dict.rhs)
  endif

  return nvim_replace_termcodes(map_dict.rhs, v:true, v:false, v:true)
endfunction

""
" Uses a maparg-like dictinoary to generate a mapping
function! std#mapping#map_dict(map_dict) abort
  call execute(std#mapping#map_dict_to_string(a:map_dict))
endfunction

""
" Turns a maparg-like dictionary into an executable string
function! std#mapping#map_dict_to_string(map_dict)
  let modifiers = ''

  if get(a:map_dict, 'expr', v:false)
    let modifiers .= '<expr>'
  endif

  if get(a:map_dict, 'nowait', v:false)
    let modifiers .= '<nowait>'
  endif

  if get(a:map_dict, 'silent', v:false)
    let modifiers .= '<silent>'
  endif

  let noremap = ''
  if get(a:map_dict, 'noremap', v:false)
    let noremap = 'nore'
  endif

  let mode = 'n'
  if get(a:map_dict, 'mode', '') != ''
    let mode = a:map_dict.mode
  endif

  let lhs = a:map_dict.lhs
  let rhs = a:map_dict.rhs

  return std#string#interpolate('{mode}{noremap}map {modifiers} {lhs} {rhs}', l:)
endfunction
