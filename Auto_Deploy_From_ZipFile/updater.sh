#!/usr/bin/env bash

# Global Variables:
DeployFolder='/root/DeployArea'
TempFolder="$DeployFolder/Temporary"
ProjectFolder='/var/www/public_html/my_project'

PrepareUpdate()
{
 cd $DeployFolder
 mkdir -p $TempFoler > /dev/null 2>&1
 unzip -qq $(ls $DeployFolder/*.zip) -d $TempFolder
 UpdateFolder=`ls -ltrh $TempFolder/|tail -n1|awk {'print $9'}`
 UpdatePath=`echo $TempFolder/$UpdateFolder`
}

DeployUpdate()
{
 systemctl stop httpd
 rm -rf $ProjectFolder/*
 mv $UpdatePath/* $ProjectFolder/
 chmod -R 775 $ProjectFolder/
 systemctl start httpd
 rm -rf $TempFolder $(ls $DeployFolder/*.zip)
}

if [ -f "`ls $DeployFolder/*.zip 2>/dev/null`" ]
then
   echo "Update file `ls $DeployFolder/*.zip` was found."
   echo "`date "+%B %d %Y %H:%M:%S"` Web Server update is started"
   echo -e "---\n`date "+%B %d %Y %H:%M:%S"` Web Server update is started" >> /var/log/gpt-updater.log
   PrepareUpdate && DeployUpdate && echo -e "`date "+%B %d %Y %H:%M:%S"` Web Server update was successfully finished\n---" >> /var/log/gpt-updater.log
   echo "`date "+%B %d %Y %H:%M:%S"` Web Server update was successfully finished"
   exit 0
else
   echo "There is no update file (*.zip) in $DeployFolder/" && exit 101
fi

