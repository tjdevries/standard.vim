function! s:get_major(obj) abort
  return a:obj.major
endfunction

function! s:get_minor(obj) abort
  return a:obj.minor
endfunction

function! s:get_patch(obj) abort
  return a:obj.patch
endfunction

function! s:set_major(obj, val) abort
  let a:obj.major = a:val
endfunction

function! s:set_minor(obj, val) abort
  let a:obj.minor = a:val
endfunction

function! s:set_patch(obj, val) abort
  let a:obj.patch = a:val
endfunction

function! s:is_semver(obj) abort
  if type(a:obj) != v:t_dict
    return v:false
  endif

  for key in ['major', 'minor', 'patch']
    if !has_key(a:obj, key)
      return v:false
    endif

    if type(a:obj[key]) != v:t_number
      return v:false
    endif
  endfor

  return v:true
endfunction


""
" Get a semver major,minor,patch object from a string, list or dict
function! std#semver#parse(obj) abort
  let semver_obj = {}

  if type(a:obj) == v:t_string
    let matches = matchlist(a:obj, '^\s*\(\d\+\)\.\(\d\+\)\.\(\d\+\)')

    if empty(matches)
        return semver_obj
    endif

    call s:set_major(semver_obj, matches[1] + 0)
    call s:set_minor(semver_obj, matches[2] + 0)
    call s:set_patch(semver_obj, matches[3] + 0)
  elseif type(a:obj) == v:t_list
    call s:set_major(semver_obj, get(a:obj, 0, 0))
    call s:set_minor(semver_obj, get(a:obj, 1, 0))
    call s:set_patch(semver_obj, get(a:obj, 2, 0))
  elseif type(a:obj) == v:t_dict
    call s:set_major(semver_obj, get(a:obj, 'major', 0))
    call s:set_minor(semver_obj, get(a:obj, 'minor', 0))
    call s:set_patch(semver_obj, get(a:obj, 'patch', 0))
  endif

  return semver_obj
endfunction

function! s:is_equal(left, right) abort
  if s:get_major(a:left) != s:get_major(a:right)
    return v:false
  endif

  if s:get_minor(a:left) != s:get_minor(a:right)
    return v:false
  endif

  if s:get_patch(a:left) != s:get_patch(a:right)
    return v:false
  endif

  return v:true
endfunction

function! s:is_not_equal(left, right) abort
  return !s:is_equal(a:left, a:right)
endfunction

function! s:is_greater_than(left, right) abort
  if s:is_equal(a:left, a:right)
    return v:false
  endif

  if s:get_major(a:left) > s:get_major(a:right)
    return v:true
  elseif s:get_major(a:left) == s:get_major(a:right)
    if s:get_minor(a:left) > s:get_minor(a:right)
      return v:true
    elseif s:get_minor(a:left) == s:get_minor(a:right)
      return s:get_patch(a:left) > s:get_patch(a:right)
    endif
  endif

  return v:false
endfunction

function! s:is_less_than(left, right) abort
  return !(s:is_greater_than(a:left, a:right) || s:is_equal(a:left, a:right))
endfunction

let s:allowed_comparisons = {
      \ '==': ['s:is_equal'],
      \ '<': ['s:is_less_than'],
      \ '>': ['s:is_greater_than'],
      \ '<=': ['s:is_less_than', 's:is_equal'],
      \ '>=': ['s:is_greater_than', 's:is_equal'],
      \ '!=': ['s:is_not_equal'],
      \ }

""
" a:left "is" a:comparison a:right
"
" Example: 
" if std#semver#is(semver_1, ">", semver_2)
" ==> Equivalent to semver_1 > semver_2
"
" Allowed comparisons:
"   ==, <, >, <=, >=, !=
function! std#semver#is(left, comparison, right) abort
  if !s:is_semver(a:left)
    echoerr "Left operation was not a valid semver item"
    return v:false
  endif

  if !s:is_semver(a:right)
    echoerr "Right operation was not a valid semver item"
    return v:false
  endif

  if !has_key(s:allowed_comparisons, a:comparison)
    echoerr "Comparison: " . a:comparison . " is not a valid comparison"
    return v:false
  endif

  let is_valid = 0
  for ref in s:allowed_comparisons[a:comparison]
    let is_valid = is_valid + funcref(ref, [a:left, a:right])()
  endfor

  return is_valid
endfunction

""
" Take a semver object and turn it into a string
function! std#semver#string(semver) abort
  return printf('%s.%s.%s',
        \ get(a:semver, 'major', 0),
        \ get(a:semver, 'minor', 0),
        \ get(a:semver, 'patch', 0)
        \ )
endfunction
