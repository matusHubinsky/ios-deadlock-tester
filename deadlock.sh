#!/bin/bash

file="proj2"
cp $file.out $file.tmp
cp $file.tmp $file.out 

NZ=$1
NU=$2
TZ=$3
TU=$4
T=$5

if [[ $6 == "-a" ]]; then
    echo "Info: deadlock detection enabled"
    auto=1
else
    auto=0 
fi

if [ -z "$NZ" ] || [ -z "$NU" ] || [ -z "$TZ" ] || [ -z "$TU" ] || [ -z "$T" ]; then
    echo "Usage: ./deadlock.sh NZ NU TZ TU T (-a)"
    echo "  NZ: Number of customers"
    echo "  NU: Number of officials"
    echo "  TZ: Maximum time in miliseconds, that customers waits after creation and before they"
    echo "      enters the post office (eventually leaves, when post office is closed)"
    echo "  TU: Maximum time of official break in miliseconds"
    echo "   F: Maximum time in miliseconds in which post office is open for new customers"
    echo "  -a: Enable deadlock detection (optional)"
    exit 1
fi

noise() {
    while true; do true; done
}

start_noise() {
    for _ in $(seq $1); do
        noise &
    done
    sleep $((RANDOM % 3 / 10))
}

stop_noise() {
    kill $(jobs -p) &>/dev/null
    wait
}

silent_kill() {
    exec > /dev/null 2>&1
    kill "$(jobs -p)"
    pgrep proj2 && killall -q proj2
    kill -- -$$
    find /dev/shm -user "$(whoami)" -delete
}

check() {
    while true; do
        current=$(date +%s)
        last_modified=$(stat -c "%Y" "$file.out")
        if [ $(( "$current-$last_modified" )) -gt 1 ]; then
            echo ""
            echo "Deadlock detected! Output file was not changed in 1 second. Killing program."
            silent_kill
            exit 0
        fi
        sleep 2
    done
}

find /dev/shm -user "$(whoami)" -delete


echo "Test 1: (no noise)"
echo -n "["
start=$(date +%s%3N)
[ $auto -eq 1 ] && check &

for _ in $(seq 20); do
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TU" "$T" >/dev/null 2>&1
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TZ" "$T" >/dev/null 2>&1
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TZ" "$T" >/dev/null 2>&1
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TU" "$T" >/dev/null 2>&1
done


echo "] $(( $(date +%s%3N) - start )) ms"
echo "Test 2: (random noise)"
echo -n "["
start=$(date +%s%3N)

for _ in $(seq 20); do
    [ $auto -eq 1 ] && check &
    start_noise $((RANDOM % 23))
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TU" "$T" >/dev/null 2>&1
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TZ" "$T" >/dev/null 2>&1
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TZ" "$T" >/dev/null 2>&1
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TU" "$T" >/dev/null 2>&1
    stop_noise
done

echo "] $(( $(date +%s%3N) - start )) ms"
echo "You are awesome! No deadlock detected!"

exit 0