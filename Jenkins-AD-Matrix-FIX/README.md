## Jenkins AD GROUP permission issue Check and Fix with the script

There is a known bug in Jenkins, when you completely change user authentication to AD through the plugin - "Matrix Based Security", periodically there are failures in the access rules (Project/Role permission) and even the admin user loses his access.Therefore I wrote small usefull script that will check "Administrator" access via curl and use "jenkins_cli" to fix the issue via reloading the configuration.


- Prepare in the script:
```bash
$ cd /root/
$ git clone https://github.com/graypit/bash-codes/tree/master/Jenkins-AD-Matrix-FIX
$ chmod +x Jenkins-AD-Matrix-FIX/checker.sh
```
- Add the following code to crontab for every 5 minutes:
```bash
$ crontab -e
*/5 * * * * cd /root/Jenkins-AD-Matrix-FIX/ && bash ./checker.sh
```

- You can also find and inspect script log in :
```bash
$ tail -f /root/Jenkins-AD-Matrix-FIX/reload.log
```