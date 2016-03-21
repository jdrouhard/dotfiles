set budspencer_colors black 083743 445659 fdf6e3 b58900 cb4b16 dc121f af005f 6c71c4 268bd2 2aa198 859900

for p in /usr/local/bin /usr/local/sbin
    if not contains $p $PATH
        set PATH $p $PATH
    end
end

if test -e $HOME/.theme
    eval sh $HOME/.theme
else
    shell_theme default
end

set -gx TERM screen-256color-bce

autoload $OMF_CONFIG/local_functions
for i in $OMF_CONFIG/local_init/*fish
    source $i
end
