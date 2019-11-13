## SNGREP Voice Dump Scheduler via TMUX Sessions

#### This script will be automatically:
- Install TMUX
- Install SNGREP
- Auto capture TCP/UDP/RTP Dump for the host that you add as an argument to the script with duration

###### For example:
We want to capture 10 minute full dump for the 123.22.11.22 host:
```bash
# You'll run the script with two argv. (host and duration)
$ ./tmux_sngrep_voip_trace_scheduler.sh 123.22.11.22 10m
# You can see your new tmux session:
$ tmux ls
```
