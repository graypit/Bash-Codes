#!/usr/bin/env bash
# Author: Habib Quliyev 01.16.21
# Global Variables:
Container_Name=`docker ps -f name=redis|grep '0.0.0.0:6379'|awk '{print $NF}'`
LogFile='script.log'
# Execute
echo -e 'del busy-customers\nFLUSHALL'|while read -r cmd
do
   docker exec -t $Container_Name redis-cli -n 0 $cmd
done ; docker restart $Container_Name && echo "`date +'%F %H:%M:%S'` Success! Redis was flushed"|tee -a $LogFile