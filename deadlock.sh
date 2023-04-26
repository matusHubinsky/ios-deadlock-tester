#!/bin/sh

NZ=$1
NU=$2
TZ=$3
TU=$4
T=$5

if [ -z "$NZ" ] || [ -z "$NU" ] || [ -z "$TZ" ] || [ -z "$TU" ] || [ -z "$T" ]; then
    echo "usage: ./deadlock.sh NZ NU TZ TU T"
    echo "  NZ: Number of customers"
    echo "  NU: Number of officials"
    echo "  TZ: Maximum time in miliseconds, that customers waits after creation and before he enters post offic (eventually leaves, when post office is closed) 0 <= TZ <= 10000 "
    echo "  TU: Maximum time of official break in miliseconds 0 <= TU <= 100"
    echo "  F: Maximum time in miliseconds in which port is open for new comers 0 <= F <= 10000"
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

echo "test 1: (no noise)"
echo -n "["
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

echo "]"
echo "test 2: (random noise)"
echo -n "["

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

echo "]"
echo "Success! No deadlock detected!"
