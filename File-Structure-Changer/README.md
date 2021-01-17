## Script for copy pdf files to new Structure as Year/Month/Day

### Explanation
In the DVS project we have `/opt/dockershare/preprod` or `prod` folder,into these directories we have a hashed directory,and in it we have a pdf file.
For example, file:
```bash
/opt/dockershare/prod/B1B555D35E0E5247E0533C03000A9A3C/AllDocuments_0102697_15-10-2020.pdf 
```
Will copied (dublicated) to new structure like below:
```bash
/opt/dockershare/prod-new-structure/2020/10/15/AllDocuments_0102697_15-10-2020.pdf
```
Script will write the descriptive log file as well
```bash
$ cat /opt/dockershare/prod-new-structure/log.txt|head -n2
2020/10/15 23:10:52
File /opt/dockershare/prod/A495678529923D86E0533C03000A8C5A//credit_1374319_02-05-2020.pdf copied to /opt/dockershare/prod-new-structure/2020/05/02
```
- To start it, just execute the following script:
```bash
$ ./Structure_Changer.sh
```
