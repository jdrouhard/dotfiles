#!/usr/bin/env bash

infocmp tmux-256color 2>/dev/null >/dev/null && exit 0

infocmp screen-256color | sed \
    -e 's/^screen[^|]*|[^,]*,/tmux-256color|tmux-256color with italics support,/' \
    -e 's/%?%p1%t;3%/%?%p1%t;7%/' \
    -e 's/smso=[^,]*,/smso=\\E[7m,/' \
    -e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
    -e '$s/$/ sitm=\\E[3m, ritm=\\E[23m,/' > /tmp/tmux-256color.terminfo
tic /tmp/tmux-256color.terminfo
rm /tmp/tmux-256color.terminfo
