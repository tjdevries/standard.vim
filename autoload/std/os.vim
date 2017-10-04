""
" Returns whether we're on windows or not
function! std#os#has_windows() abort
  return has("win32") || has("win64") || has("win95") || has("win16")
endfunction

""
" Returns whether we're on macos or not
function! std#os#has_mac() abort
  if has("mac") || has("macunix") || has("gui_mac")
    return 1
  endif
  " that still doesn't mean we are not on Mac OS
  let os = substitute(system('uname'), '\n', '', '')
  return os == 'Darwin' || os == 'Mac'
endfunction
