#### Shell script for kicking out SSH Clients inside the Server

- For FAST starting to use the script run the following lines:
```bash
$ echo "alias kick-from-ssh='bash <(wget -qO- https://raw.githubusercontent.com/graypit/bash-codes/master/Kick_Out_SSH/kick-ssh.sh)'" >> $HOME/.bash_profile
$ source !$
```

- Or you need prepare small "environment" for the script:
```bash
$ mkdir -p /var/lib/gpt-lab/
$ cd /var/lib/gpt-lab/
$ git clone https://github.com/graypit/bash-codes.git
```
- Set executable permission:
```bash
$ chmod +x bash-codes/Kick_Out_SSH/kick-ssh.sh
```
- Create alias and add to user bashrc file
```bash
$ echo "alias kick-from-ssh='/var/lib/gpt-lab/bash-codes/Kick_Out_SSH/kick-ssh.sh'" >> $HOME/.bash_profile
$ source $HOME/.bash_profile
```

There are some examples:
```bash
$ kick-from-ssh ls # List connected SSH Clients IP Addresses
$ kick-from-ssh ip 192.168.1.15 # Kick out SSH Client by IP Address
$ kick-from-ssh all # Kick out All SSH Clients except you
```
