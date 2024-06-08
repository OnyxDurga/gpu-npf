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


### ethermirror

# ../npf/npf-run.py --test ethermirror/script-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST

../npf/npf-run.py --test ethermirror/script-master-workers.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test ethermirror/script-zero-copy.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test ethermirror/script-qpc-zero-copy.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test ethermirror/script-with-copy.npf --cluster joyeux=sam --show-full --show-all $RETEST

../npf/npf-run.py --test ethermirror/script-comm-list.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test ethermirror/script-lpc-comm-list.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test ethermirror/script-comm-list-cap.npf --cluster joyeux=sam --show-full --show-all $RETEST

### lat

# ../npf/npf-run.py --test script-with-copy-lat.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-without-copy-lat.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-comm-list-lat.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-comm-list-cap-lat.npf --cluster joyeux=joyeux --show-full --show-all $RETEST



# ../npf/npf-run.py --test other/script-cpu.npf --cluster joyeux=sam --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-gpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-dpu.npf --cluster smartnic=smartnic joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-comp-cpu-gpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-mw.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

# ../npf/npf-run.py --test script-iplookup-cpu.npf --cluster joyeux=joyeux --show-full --show-all $RETEST

sudo killall -9 click
