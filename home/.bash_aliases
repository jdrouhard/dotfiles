# vim:ft=sh

export LANG=en_US.utf-8
export LC_ALL="$LANG"

export EDITOR=vim

#function gvim() { (/usr/bin/gvim -f "$@" &) }

if hash pip 2>/dev/null && hash powerline-daemon 2>/dev/null; then
    POWERLINE_DIR=$(pip show powerline-status | grep Location | cut -d' ' -f2);

    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . $POWERLINE_DIR/powerline/bindings/bash/powerline.sh
fi

. $HOME/.config/base16-shell/base16-solarized.dark.sh

alias tmux="TERM=screen-256color-bce tmux"
#alias vim="vim --servername vim"

function tmup() {
    echo -n "Updating to latest tmux environment...";
    export IFS=",";
    for line in $(tmux showenv -t $(tmux display -p "#S") | tr "\n" ",");
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-);
        else
            export "$line";
        fi;
    done;
    unset IFS;
    echo "Done"
}

