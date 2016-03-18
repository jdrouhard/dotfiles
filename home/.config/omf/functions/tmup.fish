function tmup
    for line in (tmux showenv -t (tmux display -p "#S"))
        switch $line
            case '-*'
                set -g -e (echo $line | cut -c2-)
            case '*'
                set -l name (echo $line | cut -d= -f1)
                set -l val  (echo $line | cut -d= -f2)
                set -g -x $name $val
        end
    end
end
