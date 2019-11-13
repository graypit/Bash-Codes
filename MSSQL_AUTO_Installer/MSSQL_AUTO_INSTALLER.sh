#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  MSSQL_AUTO_INSTALLER.sh
#
#         USAGE:  ./MSSQL_AUTO_INSTALLER install (or uninstall)
#
#   DESCRIPTION:  Installing MSSQL Server and dep.
#
#       OPTIONS:  ---
#  REQUIREMENTS:  Fast Internet :)
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Habib Quliyev (), graypit@gmail.com
#       VERSION:  1.0
#       CREATED:  10/08/2019 11:23:41 PM +04
#      REVISION:  ---
#===============================================================================

# Set Arrays
declare -A PrepareSystem=([1]='curl' [2]='apt-transport-https' [3]='sudo' [4]='update' [5]='libssl1.0' [6]='gnupg')
declare -A InstallMSSQL=([1]='update' [2]='mssql-server -y')
declare -A action=([1]='stop' [2]='enable' [3]='start' )
declare -A type=([1]='install' [2]='remove')

if [ "$#" -ne 1 ]
then
   echo "Usage: ./$(basename $0) install / uninstall"
   exit 155
fi

FirstInstall(){
echo "deb http://ftp.debian.org/debian jessie main" >> /etc/apt/sources.list
for i in `seq 6`
do
   if [ "$i" = "4" ]
   then
      apt ${PrepareSystem[$i]}
   else
      apt ${type[1]} -y ${PrepareSystem[$i]} 
   fi
done

apt update
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list | sudo tee /etc/apt/sources.list.d/mssql-server.list

apt ${InstallMSSQL[1]}
apt ${type[1]} ${InstallMSSQL[2]}

sleep 1 ; clear ; echo "Configure your MSSQL Server"
echo -e "\n***SET YOUR SQL DATABASE PASSWORD***\n" && sleep 2
echo -e "2\nYes\n" | sudo /opt/mssql/bin/mssql-conf setup

curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get ${type[1]} msodbcsql17 -y
sudo apt-get ${type[1]} mssql-tools unixodbc-dev -y
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

for i in `seq 3`
do
   systemctl ${action[$i]} mssql-server
done
}

Uninstall(){
for i in `seq 6`
do
  if [ "$i" = "4" ]
  then
      echo "Without ${PrepareSystem[$i]} system..."
  else
      apt ${type[2]} -y ${PrepareSystem[$i]} 
  fi
done

apt ${type[2]} ${InstallMSSQL[2]}
apt ${type[2]} msodbcsql17 -y
apt ${type[2]} mssql-tools unixodbc-dev -y
}

if [ "$1" = 'install' ]
then
   FirstInstall
   if [ "$?" = "0" ]
   then
      echo -e "\n\n\n***MSSQL Server Successfully Installed***\n\n\n"
   else
      echo 'Warning!!! MSSQL Server Installation failed !'
      exit 101
   fi
fi

if [ "$1" = 'uninstall' ]
then
   Uninstall
   if [ "$?" = "0" ]
   then
      echo -e "\n\n\n***MSSQL Server Successfully Uninstalled***\n\n\n"
   else
      echo 'Warning!!! MSSQL Server Uninstall failed !'
      exit 101
   fi
fi
