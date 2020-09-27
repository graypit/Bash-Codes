#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  checker.sh
#
#         USAGE:  checker.sh
#
#   DESCRIPTION:  Small script to fix the Jenkins permission issue
#
#        AUTHOR:  Habib Quliyev (), graypit@gmail.com
#        NUMBER:  +994777415001
#      POSITION:  DevOps Engineer
#       VERSION:  1.0
#       CREATED:  09/7/2020 11:23:17 PM +04
#      REVISION:  ---
#===============================================================================
# Global variables for Jenkins Admin:
J_IP='http://192.168.150.38:8080/' # Set the your Jenkins IP
J_CLI='jenkins-cli.jar' # This is jenkins_cli file default name
J_User='YourJenkinsAdAdminUserWhichYouDefined' # Your Jenkins AD user that you set in AD Configuration (BIND_DN User)
J_Pass='SuperStrongAdPassword' # Your Jenkins AD password that you set in AD Configuration (BIND_DN Password)
J_CMD='reload-configuration' # Reload command for the jenkins_cli
# Global variables for Jenkins Checker Auth:
CHK_User='UserWhichMemberInAdminAdGroup' # AD Group member that got admin access in Jenkins
CHK_Token='UserInternalAPIToken' # Create Token in user setting for AD Group member above
CHK_URL="https://jenkins.example.com/user/$CHK_User/" # Jenkins URL
CHK_Field='JenkinsAdmins' # AD Group of user above
###############################
# Reload Configuration function
function Reload(){
    for try in $(seq 10)
    do
        java -jar $J_CLI -s $J_IP -auth "$J_User:$J_Pass" -webSocket $J_CMD && sleep 2.5
        CheckMember=`curl -X GET -s -u "$CHK_User:$CHK_Token" $CHK_URL -k|grep -o $CHK_Field`
        if [ -z $CheckMember ]
        then
           echo "`date +"%d/%m/%y %T"` WARNING! Admin access is still missing.Attempt:$try/10" |tee -a reload.log
           java -jar $J_CLI -s $J_IP -auth "$J_User:$J_Pass" -webSocket $J_CMD && sleep 2.5
        else
            echo "`date +"%d/%m/%y %T"` SUCCESS! You've already got Admin access in $try attempts" |tee -a reload.log
            exit
        fi
    done
    echo "`date +"%d/%m/%y %T"` CRITICAL! After 10 failures admin access is still missing" |tee -a reload.log
}
# Main | Check Status function
function CheckAndStart(){
    CheckMember=`curl -X GET -s -u "$CHK_User:$CHK_Token" $CHK_URL -k|grep -o $CHK_Field`
    if [ -z $CheckMember ]
    then
       echo "`date +"%d/%m/%y %T"` WARNING! Admin access missing...Prepairing to reload configuration" |tee -a reload.log
       Reload
    fi
}

CheckAndStart
