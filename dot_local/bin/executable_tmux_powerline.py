#!/usr/bin/env python3

import os
import site
import subprocess

def find_powerline():
    # this is the fastest way to check for existence of powerline
    powerline_dir = os.path.join(site.getusersitepackages(), "powerline")

    # if it wasn't found, it might be in a system site-package dir, but we'll
    # just import it and get its location
    if not os.path.exists(powerline_dir):
        try:
            import powerline
            powerline_dir = os.path.dirname(powerline.__file__)
        except:
            powerline_dir = ""

    return powerline_dir

powerline_location = find_powerline()

if not os.path.exists(powerline_location):
    # powerline likely not installed. install both it and the weather segment with pip
    try:
        import sys
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--break-system-packages", "git+https://github.com/jdrouhard/powerline.git@weather-segment-updates"])
        powerline_location = find_powerline()
    except:
        powerline_location = ""

if powerline_location != "":
    #subprocess.Popen(["powerline-daemon", "-q"])
    os.execlp("tmux", "tmux", "source-file", os.path.join(powerline_location, "bindings", "tmux", "powerline.conf"))
