""
" Evaluate options passed to making a new window
" Meant to be used from an autocmd
function! std#window#evaluate_options() abort
  if !has_key(b:, 'std_window_opts')
    return
  endif

endfunction
""
" Opens a temporary window
function! std#window#temp(...) abort
  let opts = {}
  if a:0 > 0
    let opts = a:1
  endif

  if get(opts, 'vertical', v:false)
    vnew
  else
    new
  endif

  set buftype=nofile

  if get(opts, 'filetype', '') !=# ''
    call execute('set filetype=' . opts.filetype)
  endif

  if get(opts, 'concealcursor', '') !=# ''
    call execute('setlocal concealcursor=' . opts.concealcursor)
  endif


  let b:std_window_opts = opts

  autocmd User StdBufferTempAutoCmd <buffer> call std#window#evaluate_options(b:std_window_opts)

  return nvim_buf_get_number(0)
endfunction

""
" Open a view to a buffer, if it's not already visible in this tabpage
function! std#window#view(num) abort
  let buf_list = tabpagebuflist(tabpagenr())

  " Don't have to do anything, the list is already visible
  if std#list#contains(buf_list, a:num)
    return
  endif

  let old_pos = getcurpos()
  let old_window = win_getid()
  new
  call nvim_set_current_buf(a:num)
  call win_gotoid(old_window)
  call setpos('.', old_pos)
endfunction
