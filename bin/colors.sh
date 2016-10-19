#!/bin/bash

# Below are the color init strings for the basic file types. A color init
# string consists of one or more of the following numeric codes:
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

function grey {
 echo "[0;;30;49m$@"
}

function red {
# 31 = Red
    echo "[0;31;49m$@"
}
function green {
# 32 = Green
    echo "[0;32;49m$@"
}

function orange {
# 33 = Orange
    echo "[0;33;49m$@"
}

function blue {
# 34 = Blue
    echo "[0;34;49m$@"
}

function purple {
# 35 = Purple
    echo "[0;35;49m$@"
}

function teal {
# 36 = Teal
    echo "[0;36;49m$@"
}

function pink {
# 37 = Pink
    echo "[0;37;49m$@"
}

function bright_green {
# 38 = Bright Green
    echo "[0;38;49m$@"
}


grey This is a test line

red Die Mother Fucker

teal Don\'t I look pretty in teal?

