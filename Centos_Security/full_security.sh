#!/usr/bin/env bash
#===============================================================================
#
#          FILE:  full_security.sh
#
#         USAGE:  full_security.sh
#
#   DESCRIPTION:  Security Script for Centos 7 
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ./full_security company_name
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Habib Quliyev (), graypit@gmail.com
#       VERSION:  1.0
#       CREATED:  10/15/2019 03:23:41 PM +04
#      REVISION:  ---
#===============================================================================


if [ "$#" -ne 1 ]
then
   echo -e "WARNING!!!\nUsage: ./$(basename $0) company_name"
   exit 155
fi


### Set Global Variables :

declare -A action=([1]='enable' [2]='start' [3]='status' )
declare -A change=([mod]='chmod' [owner]='chown')

company=$1
rootuser='root:root'

users='
habib
graypit
'
whitelist='
85.132.77.113
85.132.77.114
'
groupname=$company
password='3fMVk9dDKXyDYUgC'


permissions='
600 /etc/audit/auditd.conf
0444 /etc/bashrc /etc/csh.cshrc /etc/csh.login /etc/profile
0400 /root/.bash_profile /root/.bashrc /root/.cshrc /root/.tcshrc
444 /etc/hosts
444 /etc/services
0500 /bin/ping
0500 /bin/ping6
0500 /bin/traceroute
0400 /etc/cron.allow
0400 /etc/at.allow
0644 /etc/sysctl.conf
0644 /etc/sysctl.d/*
'

owners='
/etc/audit/auditd.conf
/etc/bashrc /etc/csh.cshrc /etc/csh.login /etc/profile
/root/.bash_profile /root/.bashrc /root/.cshrc /root/.tcshrc
/etc/cron.allow /etc/at.allow
'

PreparingUMASKandMOTD(){
echo -e "umask 077\nmesg n 2>/dev/null" > /etc/profile.d/$company.sh
cat <<EOF > /etc/motd
Devops-Team (c) 2020
EOF
}

ChangePermissions() {
for perm in $permissions
do
  ${change[mod]} $perm
done

for own in $owners
do
  ${change[owner]} $rootuser $own
done
}

DisableIPv6() {
sed -i 's/crashkernel=auto/ipv6.disable=1 crashkernel=auto/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
chown root:root /etc/ssh/sshd_config && chmod 600 /etc/ssh/sshd_config
cp -p /etc/hosts /etc/hosts.disableipv6 && sed -i 's/^[[:space:]]*::/#::/' /etc/hosts
}


PreparingAuditd() {
cat << EOF > /etc/audit/auditd.conf
# This file controls the configuration of the audit daemon
#
local_events = yes
write_logs = yes
log_file = /var/log/audit/audit.log
log_group = root
log_format = RAW
flush = INCREMENTAL_ASYNC
freq = 50
max_log_file = 8
num_logs = 5
priority_boost = 4
disp_qos = lossy
dispatcher = /sbin/audispd
name_format = NONE
##name = mydomain
max_log_file_action = ROTATE
space_left = 75
space_left_action = EMAIL
verify_email = yes
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = EMAIL
disk_full_action = SYSLOG
disk_error_action = SYSLOG
use_libwrap = yes
##tcp_listen_port = 60
tcp_listen_queue = 5
tcp_max_per_addr = 1
##tcp_client_ports = 1024-65535
tcp_client_max_idle = 0
enable_krb5 = no
krb5_principal = auditd
##krb5_key_file = /etc/audit/audit.key
distribute_network = no
EOF

for i in `seq 3`
do
   systemctl ${action[$i]} auditd >/dev/null
done
}

PreparingSysLogKernel() {
cat << EOF > /etc/audisp/plugins.d/syslog.conf
active = yes
direction = out
path = builtin_syslog
type = builtin
args = LOG_LOCAL6
format = string
EOF

cat << EOF > /etc/sysctl.d/$company.conf
net.ipv4.ip_forward=0
net.ipv4.conf.all.forwarding=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0
net.ipv4.conf.all.log_martians=0
net.ipv4.conf.default.log_martians=0
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.tcp_keepalive_time=900
net.ipv4.icmp_ignore_bogus_error_responses=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.tcp_syncookies=1
net.ipv6.conf.all.forwarding=0
net.ipv6.conf.default.forwarding=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.default.accept_ra=0
fsuid_dumpable=0
kernel.exec-shield=1
kernel.randomize_va_space=2
EOF
sysctl -p
}


PreparingModProbe() {
echo "install dccp /bin/true" >> /etc/modprobe.d/$company.conf
echo "install sctp /bin/true" >> /etc/modprobe.d/$company.conf
echo "install rds /bin/true" >> /etc/modprobe.d/$company.conf
echo “install tipc /bin/true” >> /etc/modprobe.d/$company.conf
cd /etc/ && echo root > cron.allow && echo root > at.allow
}


PreparingSSHUsers(){
cat << EOF > /etc/sudoers.d/proschool
## Allow proschool group members to run commands
%$company         ALL=(ALL)      ALL
EOF

groupadd $groupname
sed -i "s/#Port 22/Port 10022/" /etc/ssh/sshd_config
sed -i "s/#PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/#MaxAuthTries 6/MaxAuthTries 4/" /etc/ssh/sshd_config
sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/" /etc/ssh/sshd_config
sed -i "s/#ClientAliveCountMax 3/ClientAliveCountMax 0/" /etc/ssh/sshd_config
sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 3600/" /etc/ssh/sshd_config
echo "AllowGroups $company " >> /etc/ssh/sshd_config

for user in $users
do
  useradd $user >/dev/null
  usermod -a -G $groupname $user >/dev/null
  echo -e "$password\n$password\n" | passwd $user >/dev/null
done
}

PreparingFirewallD(){
systemctl start firewalld
firewall-cmd --permanent --new-zone=$company
firewall-cmd --reload
firewall-cmd --zone=$company --change-interface=eth0
firewall-cmd --reload
firewall-cmd --set-default-zone=$company

for ip in $whitelist
do
   firewall-cmd --permanent --zone=$company --add-rich-rule="rule family="ipv4" source address="$ip/32" accept"
done
# Block ICMP (allow from Contabo Nagios Server)
firewall-cmd --permanent --zone=$company --add-icmp-block-inversion
firewall-cmd --permanent --zone=$company --add-rich-rule='rule protocol value=icmp family=ipv4 source address="79.143.191.54/32" accept' 
firewall-cmd --reload
systemctl enable firewalld
firewall-cmd --list-all
}
### Start:
clear && echo "Configuring and start AuditD" && sleep 1
PreparingAuditd
echo "Configuring and Optimizing Syslog and Kernel Parameters" && sleep 1
PreparingSysLogKernel
echo "Configuring and Optimizing ModProbe" && sleep 1
PreparingModProbe
echo -e "Configure SSH Parameters and Deny root access.Preparing New SSH Users with Password : $password\n" && sleep 1
PreparingSSHUsers
echo "Configure UMASK and set MOTD" && sleep 1
PreparingUMASKandMOTD
echo "Configure GRUB parameters.Disable IPV6" && sleep 1
DisableIPv6
echo "Start and Configure FirewallD" && sleep 1
PreparingFirewallD
echo -e "\nSuccess!!! Your SSH Port: 10022 / Your SSH Password: $password\nSSH Users:\n1.- jamal\n2.- habib\n3.- zaur\n4.- inad\nYou should restart the system"
