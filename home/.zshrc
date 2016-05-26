# Options
setopt correct
unsetopt correctall

# Path
export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin

for path_candidate in /opt/local/sbin \
    /opt/bats/bin \
    /opt/local/bin \
    ~/.local/bin \
    ~/bin
do
    if [ -d ${path_candidate}  ]; then
        export PATH=${path_candidate}:${PATH}
    fi
done

# Plugins
source ~/.zsh/zgenrc

# Environment variables
export LANG=en_US.utf-8
export LC_ALL="$LANG"
export EDITOR=vim
export LESS=-MIRXF

# Set up bindings
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vivis 'jk' vi-visual-exit
bindkey -M vivli 'jk' vi-visual-exit
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M menuselect '[Z' reverse-menu-complete

# Aliases
function exists {
    whence -w $1 >/dev/null
}
exists _zsh_tmux_plugin_run && tmux_func="_zsh_tmux_plugin_run" || tmux_func="tmux"
alias tmux="TERM=screen-256color-bce $tmux_func" # honestly I have no idea why the bce is necessary
alias ec='emacsclient -t'
alias ecgui='emacsclient -c'

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
