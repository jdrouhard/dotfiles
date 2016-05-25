function psgrep {
    ps wwwaux | egrep "($1|%CPU)" --color=always | grep -v grep
}

alias psg="psgrep"
