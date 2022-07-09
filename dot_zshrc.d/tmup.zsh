# Update tmux
function tmup() {
    echo -n "Updating to latest tmux environment..."
    local -a lines
    lines=("${(@f)$(tmux showenv -t $(tmux display -p "#S"))}")
    for line in $lines
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-)
        else
            export "$line"
        fi
    done
    echo "Done"
}

