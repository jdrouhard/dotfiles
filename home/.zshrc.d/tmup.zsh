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

