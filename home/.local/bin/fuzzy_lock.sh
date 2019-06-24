#!/bin/bash

if pgrep i3lock > /dev/null; then
    trap - INT TERM EXIT
    exit
else
    fifo=`find $HOME/.weechat/ -name 'weechat_fifo*'`
    away=/tmp/away

    # make sure we clean up
    function finish {
        if [ -f $away ] ; then
            echo "*/away" > $fifo
            rm $away
        fi
        pkill -P $$
    }
    trap finish INT TERM EXIT

    function blank_screen_and_away {
        sleep 300
        echo "*/away away" > $fifo
        touch $away
        xset dpms force off
    }

    blank_screen_and_away &

    # lock the screen
    i3lock -n -k -u --blur 5
fi
