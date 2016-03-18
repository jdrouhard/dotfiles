set budspencer_colors black 083743 445659 fdf6e3 b58900 cb4b16 dc121f af005f 6c71c4 268bd2 2aa198 859900

#bind -M insert -m default jj force-repaint
set -g NINJA_STATUS "[0m[[31m%u[0m/[33m%r[0m/[32m%f[36m %o/s[0m] "

if [ ! -f '$HOME/.theme' ]
    shell_theme atelierforest
else
    eval sh $HOME/.theme
end

