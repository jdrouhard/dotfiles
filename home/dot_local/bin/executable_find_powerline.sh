#!/bin/bash

python_path=$(which python3 2>/dev/null || which python 2>/dev/null)
packages=$($python_path -m pip show powerline-status 2>/dev/null | grep Location | awk '{print $2}')
echo $packages'/powerline'
