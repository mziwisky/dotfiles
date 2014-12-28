" with CtrlP, if file is already open, open new instance
" anyway (instead of trying to jump to open window)
let g:ctrlp_switch_buffer = 0

let ignored_dirs='node_modules' "TODO: just messing with this. would be nice to make NerdTree ignore node_modules too. there is probably a good way to do this 'globally', like with wildignore or something
" in fact, look into g:ctrlp_custom_ignore

" The Silver Searcher
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore '.ignored_dirs

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
