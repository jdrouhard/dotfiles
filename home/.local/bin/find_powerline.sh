python_path=$(which python3 2>/dev/null || which python 2>/dev/null)

$python_path <<EOF
from __future__ import print_function

import site
import os

for dir in site.getsitepackages():
    attempt = os.path.join(dir, 'powerline')
    if os.path.exists(attempt):
        print(attempt)
EOF
