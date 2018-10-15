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

  redraw!

  set buftype=nofile

  if get(opts, 'filetype', '') !=# ''
    call execute('set filetype=' . opts.filetype)
  endif

  if get(opts, 'concealcursor', '') !=# ''
    call execute('setlocal concealcursor=' . opts.concealcursor)
  endif


  let b:std_window_opts = opts

  if v:false
    augroup StdBuffer
      autocmd!
      autocmd User StdBufferTempAutoCmd <buffer> call std#window#evaluate_options()
    augroup END
  endif
  " doautocmd User StdBufferTempAutoCmd

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
  try
    call nvim_set_current_buf(a:num)
  catch
    echom "Couldn't find buffer: " . a:num
  endtry
  call win_gotoid(old_window)
  call setpos('.', old_pos)
endfunction

""
" Move to a visible buffer
function! std#window#goto(buf_id) abort
  call std#window#view(a:buf_id)
  call win_gotoid(bufwinid(a:buf_id))
endfunction

""
" Move Cursor To Bottom
function! std#window#set_cursor_bottom(win_id) abort
  if a:win_id < 0
    return
  endif

  call nvim_win_set_cursor(a:win_id, [nvim_buf_line_count(nvim_win_get_buf(a:win_id)), 1])
endfunction
