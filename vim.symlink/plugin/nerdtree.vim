if exists("g:ignore_dirs")
  let NERDTreeIgnore=split(g:ignore_dirs)
endif

let NERDTreeMinimalUI=1

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" by default, if a file is already open (in any tab), selecting it in nerdtree
" will just take you to that file.  i want it to open it wherever i am.
" this line makes that happen when you open with <CR>
let NERDTreeCustomOpenArgs={'file': {'reuse':'', 'where':'p', 'keepopen':1}}

" and this makes it happen when you open with `o`.
" this is done with `autocmd VimEnter *` so that it runs _after_ nerdtree
" initializes (and therefore provides the NERDTreeAddKeyMap function).
" alternativelyk, i could move this part to
" `~/.vim/nerdtree_plugin/<anything>.vim` _without_ the `autocmd VimEnter *`,
" because nerdtree would source that after it sets up all its default
" keybindings, but I could not move the `NERDTreeCustomOpenArgs` there because
" that has to be set _before_ nerdtree initializes.  i'd rather have these two
" things next to each other like this.  but if i ever decide to lazy-load
" nerdtree, then i'll have to split them up like that.
autocmd VimEnter * call NERDTreeAddKeyMap({
      \ 'override': 1,
      \ 'key': 'o',
      \ 'callback': 'NERDTreeOpenRightHereYouBitch',
      \ 'quickhelpText': 'open node',
      \ 'scope': 'FileNode' })

function! NERDTreeOpenRightHereYouBitch(node)
    call a:node.open({'reuse':'', 'where':'p', 'keepopen':1})
endfunction
