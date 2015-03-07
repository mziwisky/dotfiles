" don't open buffer for first search result
cabbrev Ag Ag!
if exists("g:ignore_dirs")
  let g:agprg="ag --ignore ".join(split(g:ignore_dirs), " --ignore ")
endif
" no column numbers
let g:agformat="%f:%l:%m"
" highlight matches
let g:aghighlight=1
" disable the 'custom mappings' so QFEnter plugin can take over
let g:ag_apply_qmappings=0
" disable them for the LAg variants too, even tho i don't use them
let g:ag_apply_lmappings=0

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
