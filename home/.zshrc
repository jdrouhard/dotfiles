# Options
setopt correct
unsetopt correctall
setopt NO_NOMATCH
setopt rm_star_silent

stty -ixon
stty -ixoff

export FZF_BASE=$HOME/.config/nvim/plugged/fzf
export PATH=~/.local/bin:/usr/local/bin${PATH:+:${PATH}}

# Plugins
source ~/.zsh/zgenrc

zstyle :omz:plugins:ssh-agent agent-forwarding on

# Environment variables
export LANG=en_US.utf-8
export LC_ALL="$LANG"
export LESS=-MIRXF
export NINJA_STATUS="[0m[[31m%u[0m/[33m%r[0m/[32m%f[36m %o/s [35m%e[0m] "
if hash nvim 2>/dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Set up bindings
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M menuselect '[Z' reverse-menu-complete

bindkey -M vicmd 'v' visual-mode
bindkey -M vicmd 'V' visual-line-mode

autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done


# aliases
alias sudo="/usr/bin/sudo -E"
alias which="builtin which"

# set some history options
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify

# set some more options
setopt pushd_ignore_dups
setopt pushd_silent

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Long running processes should return time after they complete. Specified
# in seconds.
#REPORTTIME=2
#TIMEFMT="%U user %S system %P cpu %*Es total"

# Completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")';

# Make it easy to append your own customizations that override the above by
# loading all files from .zshrc.d directory. Also load all files in
# subdirectories of .zshrc.other.d to make it easy to symlink other castles
function source_dir {
    for dotfile in $1/*.zsh; do
        if [ -r "${dotfile}" ]; then
            source "${dotfile}"
        fi
    done
}
source_dir ~/.zshrc.d
for dir in ~/.zshrc.other.d/*; do
    source_dir $dir
done

# Dedupe the PATH environment variable
typeset -U PATH path
