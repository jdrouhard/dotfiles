#!/bin/bash

#WALLPAPERS=/usr/share/backgrounds
WALLPAPERS=/home/jdrouhard/Downloads/Desktoppr
ALIST=(`ls -w1 $WALLPAPERS/*{png,jpg,jpeg} 2>/dev/null`)
RANGE=${#ALIST[*]}
SHOW1=$(( $RANDOM % $RANGE ))
SHOW2=$(( $RANDOM % $RANGE ))
SHOW3=$(( $RANDOM % $RANGE ))
SHOW4=$(( $RANDOM % $RANGE ))

feh --bg-fill ${ALIST[$SHOW1]} ${ALIST[$SHOW2]} ${ALIST[$SHOW3]} ${ALIST[$SHOW4]}
