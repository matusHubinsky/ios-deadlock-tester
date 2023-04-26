# IOS project 2. Deadlock tester
A simple bash script that try to find deadlock by runing **proj2** executable 160 times. First tests are simple, with no noise functions runnig. Second tests runs noise functions and increasses the chance of deadlock. After finding a deadlock, script will stop and it needs to be killed with pressing **^c** or `killall deadlock.sh` command.

## Usage
1. Make script executable by: \
`chmod +x deadlock.sh`

2. Run in a directory with compilet project executable named **proj2**: \
`./deadlock.sh 3 2 100 100 100"`

## Output
Output when no deadlock is detected:
```
test 1: (no noise)
[################################################################################]
test 2: (random noise)
[################################################################################]
Sucess! No deadlock detected!
```

Output when deadlock ocurs:
```
test 1: (no noise)
[################################################################################]
test 2: (random noise)
[#########
```