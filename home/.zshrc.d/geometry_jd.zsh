# Geometry (John Drouhard)
# Based on Avit and Pure and original Geometry
# geometry: https://github.com/frmendes/geometry
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure

PROMPT_SYMBOL='▲'
EXIT_VALUE_SYMBOL="%{$fg_bold[red]%}△%{$reset_color%}"
RPROMPT_SYMBOL='◇'

GIT_DIRTY="%{$fg[red]%}⬡%{$reset_color%}"
GIT_CLEAN="%{$fg[green]%}⬢%{$reset_color%}"
GIT_REBASE="\uE0A0"
GIT_UNPULLED="⇣"
GIT_UNPUSHED="⇡"

_git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

_git_dirty() {
  if test -z "$(git status --porcelain --ignore-submodules)"; then
    echo $GIT_CLEAN
  else
    echo $GIT_DIRTY
  fi
}

_git_rebase_check() {
  git_dir=$(git rev-parse --git-dir)
  if test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"; then
    echo "$GIT_REBASE"
  fi
}

_git_remote_check() {
  local_commit=$(git rev-parse @ 2>&1)
  remote_commit=$(git rev-parse @{u} 2>&1)
  common_base=$(git merge-base @ @{u} 2>&1) # last common commit

  if [[ $local_commit == $remote_commit ]]; then
    echo ""
  else
    if [[ $common_base == $remote_commit ]]; then
      echo "$GIT_UNPUSHED"
    elif [[ $common_base == $local_commit ]]; then
      echo "$GIT_UNPULLED"
    else
      echo "$GIT_UNPUSHED $GIT_UNPULLED"
    fi
  fi
}

_git_symbol() {
  echo "$(_git_rebase_check) $(_git_remote_check) "
}

_git_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "$(_git_symbol)%F{242}$(_git_branch)%{$reset_color%} :: $(_git_dirty)"
  fi
}

_print_title() {
  print -n '\e]0;'
  print -Pn $1
  print -n '\a'
}

# Show current command in title
_set_cmd_title() {
  _print_title "${2} @ %m"
}

# Prevent command showing on title after ending
_set_title() {
  _print_title '%~'
}

NORMAL_INDICATOR="%{$fg_bold[green]%}NORMAL%{$reset_color%} "
VISUAL_INDICATOR="%{$fg_bold[magenta]%}VISUAL%{$reset_color%} "
VLINE_INDICATOR="%{$fg_bold[magenta]%}V-LINE%{$reset_color%} "
INSERT_INDICATOR=""

function _vi_mode_indicator() {
    echo "${${${${KEYMAP/vivli/$VLINE_INDICATOR}/vivis/$VISUAL_INDICATOR}/vicmd/$NORMAL_INDICATOR}/(main|viins)/$INSERT_INDICATOR}"
}

geometry_prompt() {
  autoload -U add-zsh-hook

  add-zsh-hook preexec  _set_cmd_title
  add-zsh-hook precmd   _set_title

  PROMPT='%(?.$PROMPT_SYMBOL.$EXIT_VALUE_SYMBOL) %m %{$fg[magenta]%}:: %{$fg[blue]%}%3~%{$reset_color%} $(_vi_mode_indicator)%% '

  PROMPT2=' $RPROMPT_SYMBOL '
  RPROMPT='%(?..%{$fg[red]%}%? ↵%{$reset_color%} )$(_git_info)'
}

geometry_prompt
