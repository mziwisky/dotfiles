let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_ruby_mri_exec = filereadable($HOME.'/.rbenv/shims/ruby') ? $HOME.'/.rbenv/shims/ruby' : 'ruby'
