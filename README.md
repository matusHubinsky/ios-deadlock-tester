# IOS project 2. Deadlock tester
A simple bash script that tries to find deadlock by running **proj2** executable 160 times. First suite of tests are simple, with no noise functions runnig. Second suite of tests run noise functions and increas the chance of deadlock. After finding a deadlock, script will stop and it needs to be killed by pressing **ctrl-c** or `killall deadlock.sh` command.

## Usage
1. Make script executable by: \
```
chmod +x deadlock.sh
```

2. Run in a directory with compiled project executable named **proj2**: \
```
./deadlock.sh 3 2 100 100 100
```

3. Example (in your Makefile):
```
deadlock: all
    @./deadlock.sh 5 3 0 0 0
    @./deadlock.sh 1 3 10 10 0
    @./deadlock.sh 3 2 100 100 100
    @./deadlock.sh 33 22 100 100 1000
    @./deadlock.sh 100 100 100 100 1000
```

## Output
when no deadlock is detected:
```
test 1: (no noise)
[################################################################################]
test 2: (random noise)
[################################################################################]
Success! No deadlock detected!
```

when deadlock ocurs:
```
test 1: (no noise)
[################################################################################]
test 2: (random noise)
[#########
```

wrong input:
```
Usage: ./deadlock.sh NZ NU TZ TU T
  NZ: Number of customers
  NU: Number of officials
  TZ: Maximum time in miliseconds, that customers waits after creation and before they
      enters the post office (eventually leaves, when post office is closed)
  TU: Maximum time of official break in miliseconds
  F:  Maximum time in miliseconds in which post office is open for new customers
```