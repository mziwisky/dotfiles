" the below works, but only if the CWD has a `node_modules` in it. so, most of
" the time, no worky for tweed.  running eslint on save is slow anyway, so screw it.
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe = '$(npm bin)/eslint'

let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_ruby_mri_exec = filereadable($HOME.'/.rbenv/shims/ruby') ? $HOME.'/.rbenv/shims/ruby' : 'ruby'

" scala checking is crazy slow
let g:syntastic_scala_checkers = ['']
