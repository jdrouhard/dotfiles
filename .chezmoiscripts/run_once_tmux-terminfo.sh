#!/usr/bin/env bash

infocmp tmux-256color 2>/dev/null >/dev/null
if [ $? -eq 0 ]; then
    infocmp -x tmux-256color | grep Smulx 2>/dev/null >/dev/null && exit 0
    infocmp -x tmux-256color | sed \
        -e '$s/$/ Smulx=\\E[4:%p1%dm,/' > /tmp/tmux-256color.terminfo
else
    infocmp -x screen-256color | sed \
        -e 's/^screen[^|]*|[^,]*,/tmux-256color|tmux-256color with italics support,/' \
        -e 's/%?%p1%t;3%/%?%p1%t;7%/' \
        -e 's/smso=[^,]*,/smso=\\E[7m,/' \
        -e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
        -e '$s/$/ sitm=\\E[3m, ritm=\\E[23m, Smulx=\\E[4:%p1%dm,/' \
        -e '$s/$/ smxx=\\E[9m, rmxx=\\E[29m,/' > /tmp/tmux-256color.terminfo
fi
tic -x /tmp/tmux-256color.terminfo
rm /tmp/tmux-256color.terminfo
