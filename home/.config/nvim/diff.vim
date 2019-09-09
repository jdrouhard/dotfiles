Ghdiffsplit :1:%
exe 1 . "wincmd w"
Gvdiffsplit!
call feedkeys(winnr()."\<C-W>jgg", 'n')
