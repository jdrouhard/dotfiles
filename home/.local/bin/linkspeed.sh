#!/bin/bash

speed=$(ethtool eth0 2>/dev/null | grep Speed | awk '{ print $2 }')
#speed=$(dmesg -T | grep -i duplex | tail -1 | awk '{print $12$13}')

echo $speed
