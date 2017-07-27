function! std#string#byte(s, i) abort
  return luaeval('string.byte(_A.s, _A.i)', {'s': a:s, 'i': (a:i + 1)})
endfunction

function! std#string#upper(s) abort
  return luaeval('string.upper(_A)', a:s)
endfunction

function! std#string#contains(s, sub) abort
  return stridx(a:s, a:sub) >= 0
endfunction
