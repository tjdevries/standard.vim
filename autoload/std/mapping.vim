""
" Send the original global mapping, if it exists.
" Otherwise just send the actual item itself.
" This lets you add buffer overrides for things, but still send the original
" global one if you want!
function! std#mapping#execute_global(mode, mapping) abort
  " I don't think this is possible to do in vim,
  " since you can't get the global map if there is a buffer map
  if !has('nvim') || !exists('nvim_get_keymap')
    return ''
  endif

  let map_list = nvim_get_keymap(a:mode)
  call filter(map_list, { idx, val -> val.lhs == a:mapping})

  " If there were no mappings, or somehow more than one,
  " just return execute the string like we would have otherwise
  if len(map_list) != 1
    return nvim_replace_termcodes(a:mapping, v:true, v:false, v:true)
  endif

  let map_dict = map_list[0]

  return std#mapping#execute_dict(map_dict)
endfunction

function! std#mapping#execute_dict(map_dict) abort
  if a:map_dict.expr
    return eval(a:map_dict.rhs)
  endif

  return nvim_replace_termcodes(a:map_dict.rhs, v:true, v:false, v:true)
endfunction

""
" Uses a maparg-like dictinoary to generate a mapping
function! std#mapping#map_dict(map_dict) abort
  return execute(std#mapping#map_dict_to_string(a:map_dict))
endfunction

function! std#mapping#unmap_dict(unmap_dict) abort
  return execute(std#mapping#unmap_dict_to_string(a:unmap_dict))
endfunction

""
" Turns a maparg-like dictionary into an executable string
function! std#mapping#map_dict_to_string(map_dict)
  let modifiers = std#mapping#get_modifiers(a:map_dict)

  let noremap = ''
  if get(a:map_dict, 'noremap', v:false)
    let noremap = 'nore'
  endif

  let mode = std#mapping#get_mode(a:map_dict)

  let lhs = a:map_dict.lhs
  let rhs = a:map_dict.rhs

  return std#string#interpolate('{mode}{noremap}map {modifiers} {lhs} {rhs}', l:)
endfunction

""
" Unamp a dictionary string
function! std#mapping#unmap_dict_to_string(unmap_dict) abort
  let mode = std#mapping#get_mode(a:unmap_dict)
  let modifiers = std#mapping#get_modifiers(a:unmap_dict)
  let lhs = a:unmap_dict.lhs

  return std#string#interpolate('{mode}unmap {modifiers} {lhs}', l:)
endfunction

""
" Get the modifiers of a mapping dictionar
function! std#mapping#get_modifiers(map_dict) abort
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

  if get(a:map_dict, 'buffer', v:false)
    let modifiers .= '<buffer>'
  endif

  return modifiers
endfunction

""
" Get the mode of a mapping dictionary
function! std#mapping#get_mode(map_dict) abort
  let mode = 'n'
  if get(a:map_dict, 'mode', '') != ''
    let mode = a:map_dict.mode
  endif

  return mode
endfunction
