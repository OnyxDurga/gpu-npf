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

../npf/npf-run.py --test script-cpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

../npf/npf-run.py --test script-gpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-dpu.npf --cluster smartnic=smartnic joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-comp-cpu-gpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-mw.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-iplookup-cpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

sudo killall -9 click
