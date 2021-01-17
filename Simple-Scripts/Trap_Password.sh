#!/usr/bin/env bash
# Author: Habib Quliyev
#Date: 20.07.19 02:50 PM

trap "" SIGTSTP
trap '' 2

function Trap-it-Baby () {
   read -p "Enter Logout password or close SSH session : " logout
   if [[ $logout == "close" || $logout == "exit" ]]
   then
      trap 2 && echo "Success!!!"              
   else
      echo "Your password is wrong! Try again"
      Trap-it-Baby
   fi
}

Trap-it-Baby