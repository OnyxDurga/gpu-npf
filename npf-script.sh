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

../npf/npf-run.py --test baseline/scripts-baseline.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output baseline.csv


### EtherMirror

# ../npf/npf-run.py --test ethermirror/script-ethermirror-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-cpu.csv
# ../npf/npf-run.py --test ethermirror/script-ethermirror-gpu-commlist.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-gpu-commlist.csv
# ../npf/npf-run.py --test ethermirror/script-ethermirror-gpu-coalescent.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-gpu-coalescent.csv
# ../npf/npf-run.py --test ethermirror/script-ethermirror-gpu-mw.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-gpu-mw.csv


### CRC

# ../npf/npf-run.py --test crc/script-crc-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output crc-cpu.csv
# ../npf/npf-run.py --test crc/script-crc-gpu-commlist.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output crc-gpu-commlist.csv
# ../npf/npf-run.py --test crc/script-crc-gpu-coalescent.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output crc-gpu-coalescent.csv


### IP Lookup

# ../npf/npf-run.py --test iplookup/script-iplookup-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output iplookup-cpu.csv
# ../npf/npf-run.py --test iplookup/script-iplookup-gpu-commlist.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output iplookup-gpu-commlist.csv
# ../npf/npf-run.py --test iplookup/script-iplookup-gpu-coalescent.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output iplookup-gpu-coalescent.csv


### Doca

# ../npf/npf-run.py --test script-doca.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output iplookup-doca.csv


sudo killall -9 click
