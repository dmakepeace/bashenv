#!/bin/bash


#include .myaliases if it exists
if [ -f "$HOME/.myaliases" ]; then
        . "$HOME/.myaliases"
fi


# User specific aliases
alias plansource-devops="weechat irc://pr0fess0r@irc.freenode.net/#plansource-devops"
alias dm-centos6="ssh dmakepeace@10.8.100.105"
alias tmf="ssh dmakepeace@themakepeacefamily.com"
alias tmf-nc="ssh -Nf -L 8080:localhost:80 dmakepeace@themakepeacefamily.com"
alias professor="ssh dmakepeace@97.102.7.214"
alias professor-home="ssh dmakepeace@192.168.1.104"

# fortune - cowsay
#test -x /usr/games/fortune && /usr/games/fortune -s | cowsay -p ; echo
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH

function grey {
    echo "[0;30;49m$@"
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
function white {
	# 37 = White
	echo "[0;37;49m$@"
}
function bright_green {
	# 38 = Bright Green
	echo "[0;38;49m$@"
}
