#!/usr/bin/env bash
# by Habib Quliyev 21.02.2020 // GPT // Gr@yP1T
kill_by_ip(){
   if [ -z $1 ]
   then
     echo 'Input valid IP Address'
     exit 101
   else
     ip=$1
     session_user=$(who|grep $ip|awk {'print $1" "$2'})
     session=$(who|grep $ip|awk {'print $2'})
     if [ -z $session ]
     then
       echo "SSH Session not found by IP Address"
       exit 101
     else
       pid=$(ps aux|grep sshd|grep $session|head -n1|awk {'print $2'})
       echo 'You were kicked out from the SSH Session by Administrator' | write $session_user
       kill -9 $pid > /dev/null
       echo "SSH Client ($ip) was succesfully kicked out!"
     fi
   fi
}

kill_all_except_me(){
   my_session=$(tty|cut -c6-)
   dev_name=$(tty|cut -d'/' -f3)
   all_pid=$(ps aux|grep ssh[d]|grep $dev_name*|grep -v $my_session|awk {'print $2'})
   if [ -z "$all_pid" ]
   then
      echo 'SSH Sessions not found.(Apart from you)'
      exit 101
   else 
      kill -9 $all_pid > /dev/null
      echo 'All SSH Clients were successfully kicked out, except you!'
   fi
}

list_ip(){
   list_all=$(who|grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
   if [ -z "$list_all" ]
   then
      echo 'There is no one,apart from you'
      exit 101
   else
      echo -e "There are all connected SSH clients IP Addresses:\n$list_all"
   fi
}

if [ "$1" == "ip" ]
then
  kill_by_ip $2
elif [ "$1" == "all" ]
then
  kill_all_except_me
elif [ "$1" == "ls" ]
then
  list_ip
else
  echo "Usage: ./$(basename $0) ls / ip ~ip_address~ / all"
  exit 101
fi
