#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  md5_gpt.sh
# 
#         USAGE:  ./md5_gpt.sh 
# 
#        AUTHOR:  Habib Quliyev (), graypit@gmail.com
#       VERSION:  1.0
#       CREATED:  12/27/2019 11:30:17 AM +04
#      REVISION:  ---
#===============================================================================
SourceFolderFromSCM='/root/git-repo-files'
SourceSCMFilesList=`ls $SourceFolderFromSCM/`
DestinationAppFolder='/var/www/app-files'
DestinationAppFilesList=`ls $DestinationAppFolder/`

MD5_Diffs(){
for x in $SourceSCMFilesList
do
  for i in `md5sum $SourceFolderFromSCM/$x|awk '{print $1}'`
  do
    if [ `md5sum $DestinationAppFilesList/$x|awk '{print $1}'` != "$i" ]
    then
       echo "$i Changed"
       echo "$i is a $x"
       exit
    fi
  done
done
}

MD5_Diffs
echo 'No Diff Found'