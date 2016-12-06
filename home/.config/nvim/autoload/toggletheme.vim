" Toggle Background
" Modified:     2011 Apr 29
" Maintainer:   Ethan Schoonover
" License:      OSI approved MIT license

if exists("g:loaded_toggletheme")
    finish
endif
let g:loaded_toggletheme = 1

" noremap is a bit misleading here if you are unused to vim mapping.
" in fact, there is remapping, but only of script locally defined remaps, in
" this case <SID>TogBG. The <script> argument modifies the noremap scope in
" this regard (and the noremenu below).
nnoremap <unique> <script> <Plug>ToggleBackground <SID>TogBG
inoremap <unique> <script> <Plug>ToggleBackground <ESC><SID>TogBG<ESC>a
vnoremap <unique> <script> <Plug>ToggleBackground <ESC><SID>TogBG<ESC>gv
nnoremap <unique> <script> <Plug>Toggle256 <SID>Tog256
inoremap <unique> <script> <Plug>Toggle256 <ESC><SID>Tog256<ESC>a
vnoremap <unique> <script> <Plug>Toggle256 <ESC><SID>Tog256<ESC>gv
nnoremap <unique> <script> <Plug>ToggleTransparency <SID>TogTransparency
inoremap <unique> <script> <Plug>ToggleTransparency <ESC><SID>TogTransparency<ESC>a
vnoremap <unique> <script> <Plug>ToggleTransparency <ESC><SID>TogTransparency<ESC>gv
noremap <SID>TogBG  :call <SID>TogBG()<CR>
noremap <SID>Tog256  :call <SID>Tog256()<CR>
noremap <SID>TogTransparency  :call <SID>TogTransparency()<CR>

let s:background = &background
let s:num_colors = &t_Co

function! s:ApplyColors()
    if exists("g:colors_name")
        let l:colors_name = g:colors_name
        let &background=s:background
        let g:colors_name = l:colors_name
        exe "colorscheme " . g:colors_name
    endif
endfunction

function! s:TogBG()
    let s:background = ( s:background == "dark" ? "light" : "dark" )
    call s:ApplyColors()
endfunction

function! s:Tog256()
    let s:num_colors = ( s:num_colors == 256 ? 16 : 256 )
    let s:term_trans = ( s:num_colors == 256 ? 0 : 1 )
    exe "set t_Co=".s:num_colors
    exe "let g:".g:colors_name."_termcolors=".s:num_colors
    exe "let g:".g:colors_name."_termtrans=".s:term_trans
    call s:ApplyColors()
endfunction

function! s:TogTransparency()
    if !exists("s:term_trans")
        exe "let s:term_trans = g:".g:colors_name."_termtrans"
    endif
    let s:term_trans = ( s:term_trans == 0 ? 1 : 0 )
    exe "let g:".g:colors_name."_termtrans=".s:term_trans
    call s:ApplyColors()
endfunction

if !exists(":ToggleBG")
    command ToggleBG :call s:TogBG()
endif

if !exists(":Toggle256")
    command Toggle256 :call s:Tog256()
endif

if !exists(":ToggleTransparency")
    command ToggleTransparency :call s:TogTransparency()
endif

function s:mapActivation(mapActivation, func)
    try
        exe "silent! nmap <unique> ".a:mapActivation." <Plug>".a:func
        exe "silent! imap <unique> ".a:mapActivation." <Plug>".a:func
        exe "silent! vmap <unique> ".a:mapActivation." <Plug>".a:func
    finally
        return 0
    endtry
endfunction

function! toggletheme#mapbg(mapActivation)
    call s:mapActivation(a:mapActivation, "ToggleBackground")
endfunction

function! toggletheme#map256(mapActivation)
    call s:mapActivation(a:mapActivation, "Toggle256")
endfunction

function! toggletheme#maptransparency(mapActivation)
    call s:mapActivation(a:mapActivation, "ToggleTransparency")
endfunction

if !exists("no_plugin_maps")
    if !hasmapto("<Plug>ToggleTransparency")
        call toggletheme#maptransparency("<F4>")
    endif
    if !hasmapto("<Plug>ToggleBackground")
        call toggletheme#mapbg("<F5>")
    endif
    if !hasmapto("<Plug>Toggle256")
        call toggletheme#map256("<F6>")
    endif
endif

