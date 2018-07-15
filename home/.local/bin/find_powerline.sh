#!/usr/bin/env python

import site
import os

for dir in site.getsitepackages():
    attempt = os.path.join(dir, 'powerline')
    if os.path.exists(attempt):
        print attempt
