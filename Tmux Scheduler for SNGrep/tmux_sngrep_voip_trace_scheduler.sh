#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  tmux_sngrep_voip_trace_scheduler.sh
#
#         USAGE:  tmux_sngrep_voip_trace_scheduler.sh
#
#   DESCRIPTION:  Scheduler for VoIP Scheduler
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ./tmux_sngrep_voip_trace_scheduler.sh 10s/10m/10h/1d
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Habib Quliyev (), graypit@gmail.com
#       VERSION:  1.0
#       CREATED:  11/12/2019 02:23:41 AM +04
#      REVISION:  ---
#===============================================================================


if [ "$#" -ne 1 ]
then
   echo -e "WARNING!!!\nUsage: ./$(basename $0) 10s/10m/10h/1d\n---Example:\n./$(basename $0) 5m\nSIP Trace will be collect for 5 minutes.\n---"
   exit 123
fi
# ---
if [ -z $(which tmux) ]
then
   apt install -y tmux
fi

if [ -z $(which sngrep) ]
then
   apt install sngrep -y
   echo export NCURSES_NO_UTF8_ACS=1 >> /etc/environment
   source /etc/environment
fi

# Set Global Variables:
duration=$1
session="sip-trace-$duration"
path='/var/lib/graypit-lab/dumps'
filename=$(date +'%Y%m%d_%H:%M.pcap')
target='85.123.23.23'

set_tmux(){
commands="
mkdir -p /var/lib/graypit-lab/dumps/ 2>&1 >/dev/null
timeout $duration sngrep -d ens192 -r -O $path/$filename host $target ; exit
"

tmux new -d -s $session
tmux send-keys -t $session "$commands" ENTER
}

set_tmux

if [ $(echo $?) == '0' ]
then
   echo -e "You can take the finished file after: $duration\nFile Path: $path/$filename"
   exit 0
fi

