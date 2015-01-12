" don't open buffer for first search result
cabbrev Ag Ag!
if exists("g:ignore_dirs")
  let g:agprg="ag --ignore ".join(split(g:ignore_dirs), " --ignore ")
endif
" no column numbers
let g:agformat="%f:%l:%m"
" highlight matches
let g:aghighlight=1

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
