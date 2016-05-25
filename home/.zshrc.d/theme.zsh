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

