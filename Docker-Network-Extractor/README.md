# DockerNet
# Docker Network info extractor
## What will this script do ?

When we have a lot containers in Docker Engine 
often have to search manually in which subnet the container is located, what is its IP address, etc.
Or when we need to find out which subnet belongs to the network with detailed information in one table
Think for yourself, it takes away our precious time

Therefore, I wrote this small but useful script that will help us in a matter of seconds to find out the information listed above.

### For this you need:
```bash
$ mkdir /var/lib/gpt-lab/
$ cd /var/lib/gpt-lab/
$ git clone https://github.com/graypit/Bash-Codes.git
$ chmod +x ./Docker-Network-Extractor/dockernet.sh
```
### Create alias for it:
- If you're using zsh then:
```bash
$ echo "alias dockernet="/var/lib/gpt-lab/Bash-Codes/Docker-Network-Extractor/dockernet.sh"" >> ~/.zshrc && source ~/.zshrc
```
- If you're using bash then:
```bash
$ echo "alias dockernet="/var/lib/gpt-lab/Bash-Codes/Docker-Network-Extractor/dockernet.sh"" >> ~/.bashrc && source ~/.bashrc
```
### Examples:
```bash
$ dockernet 172.19.0.0/16
----------------------
Network Name: some-app-net
Network Subnet: 172.19.0.0/16
Network Gateway: 172.19.0.1
Number of containers: 3
----------------------
CONTAINER_NAME                   IP ADDRESS        MAC ADDRESS

some-app-front                    172.19.0.6/16     04:62:ac:11:0f:06
some-app-back                     172.19.0.13/16    04:62:ac:11:0f:0d
some-app-db                       172.19.0.8/16     04:62:ac:11:0f:08
```
