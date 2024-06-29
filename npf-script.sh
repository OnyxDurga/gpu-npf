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

# iplookup

# ../npf/npf-run.py --test iplookup/script-iplookup-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-iplookup-cpu-lat.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test iplookup/script-iplookup-gpu.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-iplookup-gpu-lat.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-iplookup-with-copy.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-iplookup-zero-copy.npf --cluster joyeux=joyeux --show-full --show-all $RETEST



# ../npf/npf-run.py --test script-iplookup-dpu.npf --cluster joyeux=joyeux smartnic=smartnic --show-full --show-all $RETEST

### EtherMirror

../npf/npf-run.py --test ethermirror/script-ethermirror-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-cpu.csv
../npf/npf-run.py --test ethermirror/script-ethermirror-gpu-commlist.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-gpu-commlist.csv
../npf/npf-run.py --test ethermirror/script-ethermirror-gpu-coalescent.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-gpu-coalescent.csv
../npf/npf-run.py --test ethermirror/script-ethermirror-gpu-mw.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output ethermirror-gpu-mw.csv

### CRC

../npf/npf-run.py --test crc/script-crc-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output crc-cpu.csv
../npf/npf-run.py --test crc/script-crc-gpu-commlist.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output crc-gpu-commlist.csv
../npf/npf-run.py --test crc/script-crc-gpu-coalescent.npf --cluster joyeux=sam --show-full --show-all $RETEST --single-output crc-gpu-coalescent.csv



sudo killall -9 click
