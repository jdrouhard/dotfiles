export LANG=en_US.utf-8
export LC_ALL="$LANG"

export IVY_REPO_PATH=/source/ThirdParty
export IVY_BACKUP_LOCATION=/source/ThirdParty

export JAVA_HOME=/usr/lib/jvm/java-7-oracle

export PATH=/opt/activator:$HOME/bin:$PATH

function gvim() { (/usr/bin/gvim -f "$@" &) }

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. ~/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh

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
            export $line;
        fi;
    done;
    unset IFS;
    echo "Done"
}

