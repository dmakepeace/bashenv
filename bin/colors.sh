#!/bin/bash

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

