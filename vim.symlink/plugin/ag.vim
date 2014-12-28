" don't open buffer for first search result
cabbrev Ag Ag!
let ignored_dirs='node_modules' "TODO: see ctrlp.vim note on ignored_dirs
let g:agprg="ag --ignore ".ignored_dirs
" no column numbers
let g:agformat="%f:%l:%m"
" highlight matches
let g:aghighlight=1

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
