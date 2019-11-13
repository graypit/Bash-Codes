#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  dockernet.sh
#
#         USAGE:  dockernet.sh IP Address
#
#   DESCRIPTION:  Find docker network extend information out
#
#        AUTHOR:  Habib Quliyev (), graypit@gmail.com
#        NUMBER:  +994777415001
#      POSITION:  DevOps Engineer
#       VERSION:  1.0
#       CREATED:  09/18/2020 1:25:17 PM +04
#      REVISION:  ---
#===============================================================================
# Global Variables
Target="$1"
CMD='docker network'
DockerNetworks=`$CMD ls|awk '{print $1}'|grep -vi 'network'`
# Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
# Check arguments count
if [ "$#" -ne 1 ]
then
    echo -e "${RED}Usage: ./$(basename $0) IP Address${NC}"
    echo "Example: ./$(basename $0) 172.18.0.0/16"
    echo "Example: ./$(basename $0) 172.18.0.0"
    echo "Example: ./$(basename $0) 172.18"
    exit 1
fi
# Function to gathering information about network
function GatheringInformation(){
    echo "----------------------"
    echo -e "Network Name: ${GREEN}`$CMD inspect $network|jq -r '.[].Name'`${NC}"
    echo -e "Network Subnet: ${GREEN}$Subnet${NC}"
    echo -e "Network Gateway: ${GREEN}`$CMD inspect $network|jq -r '.[].IPAM.Config[0].Gateway'`${NC}"
    echo -e "Number of containers: ${GREEN}`$CMD inspect $network|jq -r '.[].Containers[].Name'|wc -l`${NC}"
    echo "----------------------"
    Containers_List=('CONTAINER_NAME' ' ' `$CMD inspect $network|jq -r '.[].Containers[].Name'`)
    IP_List=('IP ADDRESS' ' ' `$CMD inspect $network|jq -r '.[].Containers[].IPv4Address'`)
    Mac_List=('MAC ADDRESS' ' ' `$CMD inspect $network|jq -r '.[].Containers[].MacAddress'`)
    ContainersCount=${#Containers_List[@]}
    PrepareTableOutput
}
# Function to prepare tables as a output
function PrepareTableOutput() {
    for((i=0;i<ContainersCount;i++))
    do
        echo ${Containers_List[$i]} $'\x1d' ${IP_List[$i]} $'\x1d' ${Mac_List[$i]}
    done | column -t -s$'\x1d' && exit 0
}
# Function to looking through Docker Network
function FindDockerNetwork(){
    for network in $DockerNetworks
    do
      Subnet=`$CMD inspect $network|jq -r '.[].IPAM.Config[0].Subnet'`
      if case "$Subnet" in $Target*) ;; *) false;; esac
      then
        GatheringInformation
      fi
    done
    echo -e "There is no network ${RED}$Target${NC} in Docker Engine"
    echo -e "${RED}Usage: ./$(basename $0) IP Address${NC}"
    exit 1
}
FindDockerNetwork
