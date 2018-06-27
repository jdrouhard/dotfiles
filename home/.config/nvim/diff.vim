Gsdiff :1
exe 1 . "wincmd w"
Gvdiff!
call feedkeys(winnr()."\<C-W>jgg", 'n')
