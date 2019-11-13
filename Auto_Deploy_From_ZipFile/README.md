#### Shell script for Code deploying by zipped file

- Set executable permission:
```bash
$ chmod +x ./updater.sh
```
- Copy *.zip file (Zip-file from SCM) to /root/DeployArea and run script
Run the script:
```bash
$ gpt-updater
# Log file in /var/log/gpt-updater.log
```
P.S Edit Global Variables into script for your own project