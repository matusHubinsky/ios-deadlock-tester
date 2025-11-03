```
██╗ ██████╗ ███████╗    ██████╗ ███████╗██████╗ ██╗      ██████╗  ██████╗██╗  ██╗
██║██╔═══██╗██╔════╝    ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝
██║██║   ██║███████╗    ██║  ██║█████╗  ██║  ██║██║     ██║   ██║██║     █████╔╝ 
██║██║   ██║╚════██║    ██║  ██║██╔══╝  ██║  ██║██║     ██║   ██║██║     ██╔═██╗ 
██║╚██████╔╝███████║    ██████╔╝███████╗██████╔╝███████╗╚██████╔╝╚██████╗██║  ██╗
╚═╝ ╚═════╝ ╚══════╝    ╚═════╝ ╚══════╝╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝
████████╗███████╗███████╗████████╗███████╗██████╗                                
╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗                               
   ██║   █████╗  ███████╗   ██║   █████╗  ██████╔╝                               
   ██║   ██╔══╝  ╚════██║   ██║   ██╔══╝  ██╔══██╗                               
   ██║   ███████╗███████║   ██║   ███████╗██║  ██║                               
   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
```   

A simple bash script that tries to find deadlock by running **proj2** executable 160 times. First suite of tests are simple, with no noise functions runnig. Second suite of tests run noise functions and increas the chance of deadlock. After finding a deadlock, script will stop and kill all **proj2** processes. When automatic deadlock detection is disables, it needs to be killed by pressing **ctrl-c** or **killall deadlock.sh** command.
More details: 
- https://atush.eu/knownledge-base/simple-bash-script-for-testing-deadlocks-in-VUT-FIT-IOS-2nd-project.html

## Usage
1. Make script executable by:
```
chmod +x deadlock.sh
```

2. Run in a directory with compiled project executable named **proj2**:
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

4. Disable automatic deadlock detection (optional argument -d):
```
$ ./deadlock.sh 100 100 100 100 0 -d
Info: automatic deadlock detection disabled
Test 1: (no noise)
[################################################################################] 9189 ms
Test 2: (random noise)
[############################
```

## Output
when no deadlock is detected:
```
Test 1: (no noise)
[################################################################################] 210 ms
Test 2: (random noise)
[################################################################################] 1426 ms
You are awesome! No deadlock detected!
```

when deadlock ocurs:
```
Test 1: (no noise)
[################################################################################] 9285 ms
Test 2: (random noise)
[#############
Deadlock detected! Output file was not changed in 1 second. Killing program.
Terminated
[1]    253046 terminated  ./deadlock.sh 100 100 100 100 0
```

wrong input:
```
Usage: ./deadlock.sh NZ NU TZ TU T (-d)
  NZ: Number of customers
  NU: Number of officials
  TZ: Maximum time in miliseconds, that customers waits after creation and before they
      enters the post office (eventually leaves, when post office is closed)
  TU: Maximum time of official break in miliseconds
   F: Maximum time in miliseconds in which post office is open for new customers
  -d: Disable automatic deadlock detection (optional)
```






