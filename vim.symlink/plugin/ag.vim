" don't open buffer for first search result
cabbrev Ag Ag!

" --vimgrep (consistent output we can parse) is available from version  0.25.0+
if split(system("ag --version"), "[ \n\r\t]")[2] =~ '\d\+.[2-9][5-9]\(.\d\+\)\?'
  let g:ag_prg="ag --vimgrep"
else
  " --noheading seems odd here, but see https://github.com/ggreer/the_silver_searcher/issues/361
  let g:ag_prg="ag --column --nogroup --noheading"
endif

if exists("g:ignore_dirs")
  let g:ag_prg.=" --ignore ".join(split(g:ignore_dirs), " --ignore ")
endif

" highlight matches
let g:ag_highlight=1
" disable the 'custom mappings' so QFEnter plugin can take over
let g:ag_apply_qmappings=0
" disable them for the LAg variants too, even tho i don't use them
let g:ag_apply_lmappings=0

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
