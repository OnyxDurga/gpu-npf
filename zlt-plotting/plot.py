import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import ticker
import numpy as np
import argparse
from pathlib import Path
import math

BAR_WIDTH = 0.2

IMPLEMS = {1: "CPU", 2: "DPU", 3: "DOCA", 4: "CL", 5: "ROI"}
COLORS= {1: "#5e8fb9", 2: "#5aae53", 3: "#ab4645", 4: "#eb5d5d", 5: "#f29696"}
FILES_FOLDER = "../results-zlt/"
ETHERMIRROR_FILES = [FILES_FOLDER + f"ethermirror-zlt-{i}.csv" for i in range(1,6)]
IPLOOKUP_FILES = [FILES_FOLDER + f"iplookup-zlt-{i}.csv" for i in range(1,6)]
CRC_FILES = [FILES_FOLDER + f"crc-zlt-{i}.csv" for i in range(1,6)]
WORKLOAD_TO_FILES = {"ethermirror": ETHERMIRROR_FILES, "iplookup": IPLOOKUP_FILES, "crc": CRC_FILES}

def process_csv_latency(file_path):
    df = pd.read_csv(file_path)

    df = df[df.RATE != 100]
    df = df[['test_index', 'SIZE', 'LOSE-RATE', 'AVG-LAT']]
    df = df.fillna(value={"LOSE-RATE": 0})
    
    aggregated_df = df.groupby(['test_index', 'SIZE']).agg(
        lose_rate_mean=('LOSE-RATE', 'mean'),
        lose_rate_std=('LOSE-RATE', 'std'),
        avg_lat_mean=('AVG-LAT', 'mean'),
        avg_lat_std=('AVG-LAT', 'std'),
    ).reset_index()

    # keep last line for each size, as this is the ZLT found by npf
    return aggregated_df.groupby('SIZE').tail(1)



if __name__=="__main__": 
    parser = argparse.ArgumentParser()
    parser.add_argument('workload', choices=['ethermirror', 'iplookup', 'crc'])
    args = parser.parse_args()
    workload = args.workload
    files = WORKLOAD_TO_FILES[workload]
    del files[2]    # remove DOCA

    fix, ax = plt.subplots(figsize=(5, 3))
    ax.grid(zorder=0, linestyle="dotted")

    max_y = 0

    for i, file in enumerate(files):
        implem_nr = int(Path(file).stem[-1])
        try:
            df = process_csv_latency(file)
        except:
            print(f"Error: file {file} does not exist")
            continue
        xlabels = df['SIZE']
        height = df['avg_lat_mean']
        yerr = df['avg_lat_std']

        if (df['lose_rate_mean'] > 0.1).any():
            print(f"Warning: There is a lose rate value greater than 0.1 for the file {file}, see below:")
            print(df)
    
        positions = np.arange(len(xlabels))
        label = IMPLEMS[implem_nr]
        ax.bar(positions + (i) * BAR_WIDTH + np.arange(0,5)* BAR_WIDTH, height / 0.000001, BAR_WIDTH, yerr=yerr/ 0.000001, label=label, zorder=3, color=COLORS[implem_nr])

        if max_y < (height + yerr).max():
            max_y = (height + yerr).max()
    
    ax.set_xlabel('Packet size (B)')
    ax.set_ylabel('Zero-Loss Throughput Latency')
    ax.yaxis.set_major_formatter(ticker.FormatStrFormatter("%dµs"))

    ax.set_xticks(positions + BAR_WIDTH*((len(files)-1)/2) + np.arange(0,5)* BAR_WIDTH)
    ax.set_xticklabels(xlabels)
    ax.tick_params(direction='in',which='both',axis='both',grid_linestyle='dotted',bottom='true',top='true',right='true',left='true',grid_color='#444444')

    ax.legend(ncol=len(files)//2, loc="upper left", fancybox=0,edgecolor='black',framealpha=1.0)
    
    max_y_rounded = int(math.ceil(max_y/0.000001 / 100.0)) * 100
    ax.set_ylim([0,max_y/0.000001])

    ax.set_ylim([0,1400])
    plt.tight_layout()
    plt.savefig(f'{workload}-zlt-LAT.pdf')
