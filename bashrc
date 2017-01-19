#!/bin/bash


if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

#include .myaliases if it exists
if [ -f "$HOME/.myaliases" ]; then
        . "$HOME/.myaliases"
fi

export PS1="\[\033[1;31m\][\u@\h \W]\$ \[\033[0m\]"

# User specific aliases
alias plansource-devops="weechat irc://pr0fess0r@irc.freenode.net/#plansource-devops"
alias dm-centos6="ssh dmakepeace@10.8.100.105"
alias tmf="ssh dmakepeace@themakepeacefamily.com"
alias tmf-nc="ssh -Nf -L 8080:localhost:80 dmakepeace@themakepeacefamily.com"
alias professor="ssh dmakepeace@97.102.7.214"
alias professor-home="ssh dmakepeace@192.168.1.104"
alias egrep='egrep --color=auto' 2>/dev/null
alias fgrep='fgrep --color=auto' 2>/dev/null
alias grep='grep --color=auto' 2>/dev/null
alias ll='ls -l --color=auto' 2>/dev/null
alias l.='ls -d .* --color=auto' 2>/dev/null
alias ls='ls --color=auto' 2>/dev/null
alias xzegrep='xzegrep --color=auto' 2>/dev/null
alias xzfgrep='xzfgrep --color=auto' 2>/dev/null
alias xzgrep='xzgrep --color=auto' 2>/dev/null
alias zegrep='zegrep --color=auto' 2>/dev/null
alias zfgrep='zfgrep --color=auto' 2>/dev/null
alias zgrep='zgrep --color=auto' 2>/dev/null
alias vi >/dev/null 2>&1 || alias vi=vim
# for bash and zsh, only if no alias is already set
alias which='(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot'


# fortune - cowsay
#test -x /usr/games/fortune && /usr/games/fortune -s | cowsay -p ; echo
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH

# Add SSH key to key ring
#ssh-add -k ~/.ssh/id_rsa

# Mount Home_NFS/dmakepeace if not available
test ! -e ~/nfs/bin/ &&  nohup sshfs -o ConnectTimeout=3 dmakepeace@ps-prod-backup-nfs.plansource.com:/home/dmakepeace/ /home/dmakepeace/nfs 2>/dev/null 

# Below are the color init strings for the basic file types. A color init
# string consists of one or more of the following numeric codes:
# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

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
