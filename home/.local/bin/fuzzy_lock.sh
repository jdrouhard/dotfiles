#!/bin/bash -m

# from http://riccomini.name/posts/linux/2012-09-25-kill-subprocesses-linux-bash/
kill_child_processes() {
    local isTopmost=$1
    local curPid=$2
    local childPids=`ps -o pid --no-headers --ppid ${curPid}`
    for childPid in $childPids
    do
        kill_child_processes 0 $childPid
    done
    if [ $isTopmost -eq 0 ]; then
        kill -9 $curPid 2>/dev/null
    fi
}


if pgrep i3lock > /dev/null; then
    trap - INT TERM EXIT
    exit
else
    fifo=`find $HOME/.weechat/ -name 'weechat_fifo_*'`
    tmpbg="$(mktemp /tmp/lock-XXXXXXXX.png)"
    away=/tmp/away

    # make sure we clean up
    function finish {
        if [ -f $away ] ; then
            echo "*/away" > $fifo
            rm $away
        fi
        rm $tmpbg
        kill_child_processes 1 $$
        exit
    }
    trap finish INT TERM EXIT

    function blank_screen_and_away {
        sleep 300
        echo "*/away away" > $fifo
        touch $away
        xset dpms force off
    }

    # create background
    scrot $tmpbg
    mogrify -scale 10% -scale 1000% -fill black -colorize 25% $tmpbg
    #convert $tmpbg -scale 5% -scale 2005% -fill black -colorize 25% $tmpbg

    blank_screen_and_away&

    # lock the screen
    i3lock -n -i $tmpbg 2>/dev/null

fi
