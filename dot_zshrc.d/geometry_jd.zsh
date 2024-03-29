# Geometry (John Drouhard)
# Based on Avit and Pure and original Geometry
# geometry: https://github.com/frmendes/geometry
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure

return 0

autoload -Uz vcs_info

PROMPT_SYMBOL='▲'
EXIT_VALUE_SYMBOL="%B%F{red}△%f%b"
PROMPT2_SYMBOL='◇'
SEPARATOR="%B%F{magenta}::%f%b"

USER_PROMPT_SYMBOL="%B%F{blue}$%f%b"
ROOT_PROMPT_SYMBOL="%B%F{red}#%f%b"

USER_HOST="%n@%m"
ROOT_HOST="%F{red}%m%f"

GIT_DIRTY="%F{red}⬡%f"
GIT_CLEAN="%F{green}⬢%f"
GIT_REBASE=""
GIT_UNPULLED="⇣"
GIT_UNPUSHED="⇡"

zstyle ':vcs_info:*' enable bzr git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' formats        "%F{242}%b%f" "%u%c"
zstyle ':vcs_info:*' actionformats  "%F{242}%b%f" "%u%c" "%B%F{yellow}%a %m%f%%b"
zstyle ':vcs_info:*' patch-format   "[%n/%a]"
zstyle ':vcs_info:*' nopatch-format "[%n/%a]"
zstyle ':vcs_info:*' unstagedstr    "$GIT_DIRTY"
zstyle ':vcs_info:git*' formats        "%c %F{242}%b%f" "%u"
zstyle ':vcs_info:git*' actionformats  "%c %F{242}%b%f" "%u" "%B%F{yellow}%a %m%f%%b"
zstyle ':vcs_info:git*' check-for-changes false # handled by git-upstream/git-dirty hooks
zstyle ':vcs_info:git*+set-message:*' hooks \
                                        git-hook-begin \
                                        git-upstream \
                                        git-dirty

function +vi-git-hook-begin() {
    if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
        # hook functions after this will not be called if non-zero is returned
        return 1
    fi
}

function +vi-git-upstream() {
    # This hook targets the 1st message in the format list (branch info)
    if [[ "$1" != "0" ]]; then
        return 0
    fi

    local_commit=$(command git rev-parse @ 2>&1)
    remote_commit=$(command git rev-parse @{u} 2>&1)
    common_base=$(command git merge-base @ @{u} 2>&1) # last common commit

    if [[ $local_commit == $remote_commit ]]; then
        return 0
    else
        if [[ $common_base == $remote_commit ]]; then
            hook_com[staged]="$GIT_UNPUSHED"
        elif [[ $common_base == $local_commit ]]; then
            hook_com[staged]="$GIT_UNPULLED"
        else
            hook_com[staged]="$GIT_UNPUSHED $GIT_UNPULLED"
        fi
    fi
}

function +vi-git-dirty() {
    # This hook targets the 2nd message in the format list (%u)
    if [[ "$1" != "1" ]]; then
        return 0
    fi

    hook_com[unstaged]=$GIT_CLEAN

    if test -n "$(command git status --porcelain --ignore-submodules 2>/dev/null)"; then
        hook_com[unstaged]=$GIT_DIRTY
    fi
}

function geometry_prompt() {
    case ${KEYMAP} in
        (main|viins)   TEXT="INSERT"; COLOR="cyan" ;;
        (vicmd)        TEXT="NORMAL"; COLOR="yellow" ;;
        (visual|viopp) TEXT="$KEYMAP"; COLOR="magenta" ;;
        (*)            TEXT="$KEYMAP"; COLOR="" ;;
    esac
    vi_mode_indicator="%B%F{$COLOR}$TEXT%f%b"

    local -a messages

    messages+=( "%(?.$PROMPT_SYMBOL.$EXIT_VALUE_SYMBOL)" )        # normal filled triangle or empty red triangle
    messages+=( "%(!.$ROOT_HOST.$USER_HOST)" )                    # root is a red hostname, user is normal user@hostname
    messages+=( "$SEPARATOR" )                                    # ::
    messages+=( "[$vi_mode_indicator]" )                          # [INSERT] or [NORMAL]
    messages+=( "%F{green}%3~%f" )                                # Current working directory with 3 parent paths
    messages+=( "%(!.$ROOT_PROMPT_SYMBOL.$USER_PROMPT_SYMBOL) " ) # root is red #, user is blue $

    PROMPT="${(j: :)messages}"
    PROMPT2=' $PROMPT2_SYMBOL '

    async_job geometry_rprompt_worker geometry_rprompt_async $PWD
}

# RPROMPT should be done asynchronously
function geometry_rprompt_async() {
    cd -q $1
    vcs_info

    messages=()
    [[ -n "$vcs_info_msg_2_" ]] && messages+=( $GIT_REBASE ${vcs_info_msg_2_} $SEPARATOR ) # action info (rebase/merge and [applied/total] patches)
    [[ -n "$vcs_info_msg_0_" ]] && messages+=( ${vcs_info_msg_0_} )                        # branch info with arrows for ahead/behind upstream
    [[ -n "$vcs_info_msg_1_" ]] && messages+=( $SEPARATOR ${vcs_info_msg_1_} )             # clean -> green filled square, dirty -> red empty square

    print "%(?..%F{red}%? ↵%f ) ${(j: :)messages}"
}

function geometry_rprompt_update() {
    local name=$1 code=$2 output=$3
    if (( code == 2)) || (( code == 3 )) || (( code == 130 )); then
        async_stop_worker geometry_rprompt_worker
        async_start_worker geometry_rprompt_worker
        async_register_callback geometry_rprompt_worker geometry_rprompt_update
    elif (( code )); then
    fi;
    RPROMPT="$output"
    zle reset-prompt
}

function zle-line-init zle-keymap-select {
    geometry_prompt
    zle reset-prompt
}

async_init
async_start_worker geometry_rprompt_worker
async_register_callback geometry_rprompt_worker geometry_rprompt_update

zle -N zle-line-init
zle -N zle-keymap-select
