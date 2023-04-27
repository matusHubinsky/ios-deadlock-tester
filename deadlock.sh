#!/bin/bash

NZ=$1
NU=$2
TZ=$3
TU=$4
T=$5

if [ -z "$NZ" ] || [ -z "$NU" ] || [ -z "$TZ" ] || [ -z "$TU" ] || [ -z "$T" ]; then
    echo "Usage: ./deadlock.sh NZ NU TZ TU T"
    echo "  NZ: Number of customers"
    echo "  NU: Number of officials"
    echo "  TZ: Maximum time in miliseconds, that customers waits after creation and before they"
    echo "      enters the post office (eventually leaves, when post office is closed)"
    echo "  TU: Maximum time of official break in miliseconds"
    echo "  F:  Maximum time in miliseconds in which post office is open for new customers"
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

find /dev/shm -user "$(whoami)" -delete

echo "Test 1: (no noise)"
echo -n "["
start=$(date +%s%3N)

for _ in $(seq 20); do
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TU" "$T"
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TZ" "$T"
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TZ" "$T"
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TU" "$T"
done


echo "] finished in: $(( $(date +%s%3N) - start )) ms"
echo "Test 2: (random noise)"
echo -n "["

start=$(date +%s%3N)
for _ in $(seq 20); do
    start_noise $((RANDOM % 23))
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TU" "$T"
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TZ" "$T"
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TZ" "$TZ" "$T"
    echo -n "#"
    ./proj2 "$NZ" "$NU" "$TU" "$TU" "$T"
    stop_noise
done

echo "] finished in: $(( $(date +%s%3N) - start )) ms"
echo "You are awesome! No deadlock detected!"