# Plugins
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
    for line in $(tmux showenv -t $(tmux display -p "#S"))
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-)
        else
            echo $line
            export "$line"
        fi
    done
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

    for theme_path in "${theme_paths[@]}"
    do
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


# Honor old .zshrc.local customizations, but print depecation warning.
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
  echo ".zshrc.local is deprecated - use files in ~/.zshrc.d instead"
fi

# Make it easy to append your own customizations that override the above by
# loading all files from .zshrc.d directory
mkdir -p ~/.zshrc.d
if [ -n "$(ls ~/.zshrc.d)" ]; then
  for dotfile in ~/.zshrc.d/*
  do
    if [ -r "${dotfile}" ]; then
      source "${dotfile}"
    fi
  done
fi

# In case a plugin adds a redundant path entry, remove duplicate entries
# from PATH
#
# This snippet is from Mislav Marohnić <mislav.marohnic@gmail.com>'s
# dotfiles repo at https://github.com/mislav/dotfiles

dedupe_path() {
  typeset -a paths result
  paths=($path)

  while [[ ${#paths} -gt 0 ]]; do
    p="${paths[1]}"
    shift paths
    [[ -z ${paths[(r)$p]} ]] && result+="$p"
  done

  export PATH=${(j+:+)result}
}

dedupe_path
