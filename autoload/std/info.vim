""
" Information regarding standard.vim
" You can use this to make sure you have the correct version
if !exists('g:standard_vim_semver_list')
  runtime! plugin/std.vim
endif

""
" Get the semver version
function! std#info#get_version() abort
  return std#semver#parse(g:standard_vim_semver_list)
endfunction

""
" Require a certain version of standard.vim
function! std#info#require(semver) abort
  let semver_obj = std#semver#parse(a:semver)

  return std#semver#is(std#info#get_version(), '>=', semver_obj)
endfunction
