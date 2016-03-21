function shell_theme -a name variant

    if test -z "$variant"
        set variant "dark"
    end

    set theme_paths "$HOME/.config/base16-shell/base16-$name.$variant.sh" \
                       "$HOME/.config/base16-shell/$name.$variant.sh"

    for path in $theme_paths
        if test -e "$path"
            ln -sf "$path" $HOME/.theme
            eval sh $HOME/.theme
            set found "true"
            break
        end
    end

    if test -z $found
        return 1
    end
end

