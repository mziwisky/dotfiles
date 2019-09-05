" gotta initialize the empty dictionary before customizing
let g:qfenter_keymap = {}
" include 'o' as an option for opening from quickfix window
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>', 'o']
" match CtrlP mappings for opening in splits and tabs
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']
