# vim:ft=sh

export LANG=en_US.utf-8
export LC_ALL="$LANG"

export EDITOR=vim

BASE16_THEME_DEFAULT="gruvbox-dark-soft"

#function gvim() { (/usr/bin/gvim -f "$@" &) }

if hash pip 2>/dev/null && hash powerline-daemon 2>/dev/null; then
    POWERLINE_DIR=$(pip show powerline-status | grep Location | cut -d' ' -f2);

    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . $POWERLINE_DIR/powerline/bindings/bash/powerline.sh
fi

#alias tmux="TERM=screen-256color-bce tmux"
#alias vim="vim --servername vim"
alias sudo="sudo -E"

stty -ixoff
stty -ixon

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

function theme() {
    local theme_name=${1}
    local variant=${2:-dark}
    local theme_paths=("$HOME/.config/base16-shell/base16-$theme_name.$variant.sh" \
                       "$HOME/.config/base16-shell/$theme_name.$variant.sh")
    local found=false

    for path in "${theme_paths[@]}"; do
        if [ -f "$path" ]; then
            ln -sf $path $HOME/.theme
            . $HOME/.theme
            found=true
            break
        fi
    done

    if [ "$found" != true ]; then
        echo "Could not find theme base16-$theme_name.$variant.sh or $theme_name.$variant.sh"
    fi
}

if [ ! -f "$HOME/.theme" ]; then
    theme $BASE16_THEME_DEFAULT
else
    . $HOME/.theme
fi
