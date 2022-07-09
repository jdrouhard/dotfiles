function psgrep {
    ps wwwaux | egrep "($1|%CPU)" --color=always | grep -wv 'grep'
}

alias psg="psgrep"
