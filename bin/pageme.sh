#!/bin/bash
#
# DESCRIPTION: Page me when this process is done running. Great for receiving
#              text messages when waiting for long running processes
#
# LIST OF EMAIL TO TEXT DOMAIS FOR MAJOR CARRIERS
# Verizon:  @vtext.com
# AT&T:     @txt.att.net
# Sprint:   @messaging.sprintpcs.com
# T-Mobile: tmomail.net

PHN_NUM="XXXXXXXXXX@messaging.sprintpcs.com"

if [ -z "$1" ]
then
	echo "Need process to watch"
	echo -e "\tEXAMPLE: $(basename $0) migrations_refresh.sh"
	exit 1
else
	PROCESS="$1"
fi

MSG="Process \"${PROCESS}\" has finished on $(hostname -s)"

while [ 1 ]
do
	if ps -ef |grep -v -E "grep|$(basename $0)" |grep $PROCESS > /dev/null
	then
		#echo "Process still running: $PROCESS"
		sleep 30
	else
		#echo "Process ended. Sending Email to $PHN_NUM"
		sendmail $PHN_NUM <<< $MSG
		exit 0
	fi
done
