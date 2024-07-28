#!/bin/sh

while getopts :r flag
do
    case "${flag}" in
        r)
            RETEST=" --force-retest"
            ;;
        \? )
            echo "Usage: $(basename $0) [-r]"
            exit 1
            ;;
    esac
done


### Baseline 
../npf/npf-run.py --test baseline/script-baseline.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output results-csv/baseline.csv


### EtherMirror
../npf/npf-compare.py "local+cpu:CPU version" "local+gpu-coalescent:GPU Coalescent version" "local+gpu-commlist:GPU Communication List version" "local+gpu-mw:GPU Master-Workers version" "local+gpu-doca:DOCA version" --test ethermirror/script-ethermirror.npf --cluster joyeux=sam --show-full --show-all --single-output results-csv/ethermirror.csv --statistics $RETEST

### IP Lookup
../npf/npf-compare.py "local+cpu:CPU version" "local+gpu-coalescent:GPU Coalescent version" "local+gpu-commlist:GPU Communication List version" "local+gpu-doca:DOCA version" --test iplookup/script-iplookup.npf --cluster joyeux=sam --show-full --show-all --single-output results-csv/iplookup.csv --statistics $RETEST

### CRC
../npf/npf-compare.py "local+cpu:CPU version" "local+gpu-coalescent:GPU Coalescent version" "local+gpu-commlist:GPU Communication List version" --test crc/script-crc.npf --cluster joyeux=sam --show-full --show-all --single-output results-csv/crc.csv --statistics $RETEST

sudo killall -9 click
