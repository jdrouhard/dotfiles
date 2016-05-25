# Plugins
source ~/.zsh/zgen/zgen.zsh
source ~/.zsh/zgenrc

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")';

# Environment variables
export LANG=en_US.utf-8
export LC_ALL="$LANG"
export EDITOR=vim
export LESS=-MIRXF

# Update tmux
function tmup() {
    echo -n "Updating to latest tmux environment..."
    for line in $(tmux showenv -t $(tmux display -p "#S"));
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-);
        else
            echo $line
            export "$line"
        fi;
    done;
    unset IFS;
    echo "Done"
}

# Color theme
BASE16_THEME_DEFAULT="atelierheath"

function theme() {
    local theme_name variant found
    local -a theme_paths

    theme_name=${1}
    variant=${2:-dark}
    theme_paths=("$HOME/.config/base16-shell/base16-$theme_name.$variant.sh" \
                       "$HOME/.config/base16-shell/$theme_name.$variant.sh")
    found=false

    for theme_path in "${theme_paths[@]}"; do
        if [ -f "$theme_path" ]; then
            ln -sfn $theme_path $HOME/.theme
            source $HOME/.theme
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
    source $HOME/.theme
fi

# Set up vi mode
bindkey -v
bindkey -v '^?' backward-delete-char
bindkey -M viins 'jk' vi-cmd-mode

# Options
setopt correct
unsetopt correctall

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify

# Share your history across all your terminal windows
setopt share_history
#setopt noclobber

# set some more options
setopt pushd_ignore_dups

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Long running processes should return time after they complete. Specified
# in seconds.
REPORTTIME=2
TIMEFMT="%U user %S system %P cpu %*Es total"

