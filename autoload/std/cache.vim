""
" Cache a variabe in a diciontary.
"
" @param cache (dict): The dictionary to store the cache in
" @param name (string): Variable name
" @param function (Funcref): Function to retrieve variable if not already cached
function! std#cache#get(cache, name, function, ...) abort
  let timeout = get(a:000, 0, -1)

  if has_key(a:cache, a:name) && a:cache[a:name] != {}
    let cached_val = s:check_cache(a:cache, a:name)

    if timeout > 0
      let last_evaluated = has_key(cached_val, 'last_evaluated') ?
            \ cached_val.last_evaluated
            \ : -1

      if last_evaluated < 0 || (localtime() - last_evaluated) > timeout
        call s:set_result(a:cache, a:name, a:function)
      endif
    endif

    return s:get_result(a:cache, a:name)
  endif

  " Never been evaluated before
  call s:set_result(a:cache, a:name, a:function)

  return s:get_result(a:cache, a:name)
endfunction

function! s:check_cache(cache, name) abort
  " If we don't have a dict, then we have to just remove the value
  if type(a:cache[a:name]) != v:t_dict
    let a:cache[a:name] = {}
  endif

  return a:cache[a:name]
endfunction

function! s:set_result(cache, name, function) abort
  let a:cache[a:name] = {
        \ 'last_evaluated': localtime(),
        \ 'result': a:function()
        \ }
endfunction

function! s:get_result(cache, name) abort
  return has_key(a:cache[a:name], 'result') ?
        \ a:cache[a:name].result
        \ : a:cache[a:name]
endfunction
