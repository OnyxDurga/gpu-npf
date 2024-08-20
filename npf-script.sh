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
../npf/npf-compare.py "local" --test baseline/script-baseline.npf --cluster joyeux=sam --show-full --show-all --single-output results-csv/baseline.csv --graph-filename graphs/baseline

### EtherMirror
../npf/npf-compare.py "local+cpu:CPU" "local+dpu:DPU" "local+gpu-doca:DOCA" "local+gpu-coalescent:ROI" "local+gpu-commlist:CL" "local+gpu-mw:MW" --test ethermirror/script-ethermirror.npf --cluster joyeux=sam smartnic=bf2-jaskier --show-full --show-all --single-output results-csv/ethermirror.csv --statistics $RETEST

### IP Lookup
../npf/npf-compare.py "local+cpu:CPU" "local+dpu:DPU" "local+gpu-doca:DOCA" "local+gpu-coalescent:ROI" "local+gpu-commlist:CL" --test iplookup/script-iplookup.npf --cluster joyeux=sam smartnic=bf2-jaskier --show-full --show-all --single-output results-csv/iplookup.csv --statistics $RETEST

### CRC
../npf/npf-compare.py "local+cpu:CPU" "local+dpu:DPU" "local+gpu-doca:DOCA" "local+gpu-coalescent:ROI" "local+gpu-commlist:CL" --test crc/script-crc.npf --cluster joyeux=sam smartnic=bf2-jaskier --show-full --show-all --single-output results-csv/crc.csv --statistics $RETEST

sudo killall -9 click
