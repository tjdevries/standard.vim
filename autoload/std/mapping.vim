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

  if map_dict.expr
    return execute(map_dict.rhs)
  endif

  return nvim_replace_termcodes(map_dict.rhs, v:true, v:false, v:true)
endfunction
