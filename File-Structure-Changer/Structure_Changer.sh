#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  Structure_Changer.sh
#
#         USAGE:  Structure_Changer.sh
#
#   DESCRIPTION:  Script for convert pdf files to new Year/Month/Day Structure
#
#       OPTIONS:  ---
#  REQUIREMENTS:  Clear Mind :)
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Habib Guliyev (), graypit@gmail.com
#       VERSION:  1.0
#       CREATED:  10/15/2020 11:40:23 PM +04
#      REVISION:  ---
#===============================================================================
# Global Variables
SourcePath='/opt/dockershare/prod'
NewPath="$SourcePath-new-structure"
# Print main information before start
echo -e "*********INFORMATION***********\n"
echo "Summary Hash Folders count is $(ls -d $SourcePath/*/|wc -l)"
echo "Summary PDF Files count is: $(ls $SourcePath/*/*.pdf|wc -l)"
echo "Let's start" && sleep 0.5
# Logging function
function Logging(){
    echo "$(date +"%Y/%m/%d %H:%m:%S")" >> $NewPath/log.txt
    echo "File $file copied to $NewStructure" >> $NewPath/log.txt
    echo "-------" >> $NewPath/log.txt
}
# Main function
function OldFilesToNewStructure(){
    for folder in $(ls -d $SourcePath/*/)
    do
        for file in $(ls $folder/*.pdf 2>/dev/null)
        do
            Day=$(ls $file|cut -f3 -d'_'|cut -f1 -d'.'|cut -f1 -d'-')
            Month=$(ls $file|cut -f3 -d'_'|cut -f1 -d'.'|cut -f2 -d'-')
            Year=$(ls $file|cut -f3 -d'_'|cut -f1 -d'.'|cut -f3 -d'-')
            NewStructure="$NewPath/$Year/$Month/$Day"
            if [ ! -d $NewStructure ]
            then
                 mkdir -p $NewStructure
            fi
            cp $file $NewStructure/
            if [ "$(echo $?)" == '0' ];then Logging ;fi
        done  
    done
}

if [ -d $SourcePath ]
then
    mkdir -p $NewPath 2>/dev/null
    OldFilesToNewStructure
else
    echo "Path $SourcePath does not exist"
    exit 1
fi