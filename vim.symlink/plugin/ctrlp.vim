" with CtrlP, if file is already open, open new instance
" anyway (instead of trying to jump to open window)
let g:ctrlp_switch_buffer = 0
" respect vim's CWD
let g:ctrlp_working_path_mode = 0

" The Silver Searcher
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  if exists("g:ignore_dirs")
    let g:ctrlp_user_command.=' --ignore '.join(split(g:ignore_dirs), " --ignore ")
  endif

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
