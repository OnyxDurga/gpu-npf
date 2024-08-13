import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import ticker
import numpy as np
import argparse
from pathlib import Path
import math
import itertools

BAR_WIDTH = 0.2

IMPLEMS = {1: "CPU", 2: "DPU", 3: "DOCA", 4: "CL", 5: "ROI"}
COLORS= {1: "#5e8fb9", 2: "#5aae53", 3: "#ab4645", 4: "#eb5d5d", 5: "#f29696"}
COLORS_2 = {3: "#1e75b4", 4: "#6b97cc", 5: "#afc5e9"}
MARKER= {3: "^", 4: '*', 5: 'd'}

FILES_FOLDER = "../results-zlt/"
ETHERMIRROR_FILES = [FILES_FOLDER + f"ethermirror-zlt-{i}.csv" for i in range(1,6)]
IPLOOKUP_FILES = [FILES_FOLDER + f"iplookup-zlt-{i}.csv" for i in range(1,6)]
CRC_FILES = [FILES_FOLDER + f"crc-zlt-{i}.csv" for i in range(1,6)]
WORKLOAD_TO_FILES = {"ethermirror": ETHERMIRROR_FILES, "iplookup": IPLOOKUP_FILES, "crc": CRC_FILES}

def process_csv_latency(file_path, groupby='SIZE'):
    df = pd.read_csv(file_path)

    df = df[df.RATE != 100]
    df = df[['test_index', groupby, 'LOSE-RATE', 'AVG-LAT']]
    
    aggregated_df = df.groupby(['test_index', groupby]).agg(
        lose_rate_mean=('LOSE-RATE', 'mean'),
        lose_rate_std=('LOSE-RATE', 'std'),
        avg_lat_mean=('AVG-LAT', 'mean'),
        avg_lat_std=('AVG-LAT', 'std'),
    ).reset_index()

    # keep last line for each size, as this is the ZLT found by npf
    return aggregated_df.groupby(groupby).tail(1)

def process_csv_throughput(file_path, groupby='SIZE'):
    df = pd.read_csv(file_path)

    df = df[df.RATE == 100]
    df = df[['test_index', groupby, 'LOSE-RATE', 'RX-RATE-MBPS']]
    
    aggregated_df = df.groupby(['test_index', groupby]).agg(
        lose_rate_mean=('LOSE-RATE', 'mean'),
        lose_rate_std=('LOSE-RATE', 'std'),
        rate_mean=('RX-RATE-MBPS', 'mean'),
        rate_std=('RX-RATE-MBPS', 'std'),
    ).reset_index()

    return aggregated_df


if __name__=="__main__": 
    parser = argparse.ArgumentParser()
    parser.add_argument('graph', choices=['batching', 'zltlatency'])
    parser.add_argument('workload', choices=['ethermirror', 'iplookup', 'crc'])
    args = parser.parse_args()

    if args.graph == 'zltlatency':
        workload = args.workload
        files = WORKLOAD_TO_FILES[workload]
        del files[2]    # remove DOCA

        fig, ax = plt.subplots(figsize=(5, 3))
        ax.grid(zorder=0, linestyle="dotted")

        max_y = 0

        for i, file in enumerate(files):
            implem_nr = int(Path(file).stem[-1])
            try:
                df_lat = process_csv_latency(file)
            except:
                print(f"Error: file {file} does not exist")
                continue
            xlabels = df_lat['SIZE']
            height = df_lat['avg_lat_mean']
            yerr = df_lat['avg_lat_std']

            if (df_lat['lose_rate_mean'] > 0.1).any():
                print(f"Warning: There is a lose rate value greater than 0.1 for the file {file}, see below:")
                print(df_lat)
        
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

    elif args.graph == 'batching':
        workload = args.workload
        files = [file.replace('zlt-', 'zlt-batching-') for file in WORKLOAD_TO_FILES[workload][2:]]

        fig_thr, ax_thr = plt.subplots(figsize=(5, 3))
        fig_lat, ax_lat = plt.subplots(figsize=(5, 3))
        ax_thr.grid(zorder=0, linestyle="dotted")
        ax_lat.grid(zorder=0, linestyle="dotted")

        max_y = 0

        for i, file in enumerate(files):
            try:
                df_lat = process_csv_latency(file, groupby='BATCH')
                df_thr = process_csv_throughput(file, groupby='BATCH')
            except:
                print(f"Error: file {file} does not exist")
                continue

            implem_nr = int(Path(file).stem[-1])
            xlabels = df_lat['BATCH']
            positions = np.arange(len(xlabels))
            spacing = np.arange(0, len(positions))
            label = IMPLEMS[implem_nr]

            # Throughput
            height = df_thr['rate_mean']
            yerr = df_thr['rate_std']
            ax_thr.bar(positions + (i) * BAR_WIDTH + spacing * BAR_WIDTH, height / 1000, BAR_WIDTH, yerr=yerr/ 1000, label=label, zorder=3, color=COLORS[implem_nr])

            # Latency 
            height = df_lat['avg_lat_mean']
            yerr = df_lat['avg_lat_std']

            if (df_lat['lose_rate_mean'] > 0.1).any():
                print(f"Warning: There is a lose rate value greater than 0.1 for the file {file}, see below:")
                print(df_lat)
        
            ax_lat.bar(positions + (i) * BAR_WIDTH + spacing * BAR_WIDTH, height / 0.000001, BAR_WIDTH, yerr=yerr/ 0.000001, label=label, zorder=3, color=COLORS[implem_nr])

            if max_y < (height + yerr).max():
                max_y = (height + yerr).max()
        
        for ax in (ax_thr, ax_lat):
            ax.set_xlabel('GPU Batching Size')
            ax.set_xticklabels(xlabels)
            ax.set_xticks(positions + BAR_WIDTH*((len(files))/2) + spacing * BAR_WIDTH)
            ax.tick_params(direction='in',which='both',axis='both',grid_linestyle='dotted',bottom='true',top='true',right='true',left='true',grid_color='#444444')
            # ax.legend(ncol=3, loc="upper center", bbox_to_anchor=(0, 1, 1, 0), fancybox=0,edgecolor='black',framealpha=1.0)

        ax_thr.set_ylabel('Throughput')
        ax_thr.yaxis.set_major_formatter(ticker.FormatStrFormatter("%dGbps"))
        ax_lat.set_ylabel('Zero-Loss Throughput Latency')
        ax_lat.yaxis.set_major_formatter(ticker.FormatStrFormatter("%dµs"))

        # lines_thr, labels_thr = ax_thr.get_legend_handles_labels()
        # lines_lat, labels_lat = ax_lat.get_legend_handles_labels()
        # lines = [x for x in itertools.chain.from_iterable(itertools.zip_longest(lines_thr, lines_lat)) if x] # alternate between the lists, so that implems are on the same column
        # labels = [x for x in itertools.chain.from_iterable(itertools.zip_longest(labels_thr, labels_lat)) if x]
        # ax_lat.legend(ncol=len(lines)//2, loc="upper center", bbox_to_anchor=(0, 1, 1, 0), fancybox=0,edgecolor='black',framealpha=1.0)

        max_y_rounded = int(math.ceil(max_y/0.000001 / 100.0)) * 100
        ax_lat.set_ylim([0,max_y/0.000001])


        ax_thr.set_ylim([0,50])
        ax_lat.set_ylim([0,600])
        fig_thr.tight_layout()
        fig_thr.savefig(f'{workload}-zlt-batching-RX-RATE.pdf')
        fig_lat.tight_layout()
        fig_lat.savefig(f'{workload}-zlt-batching-LAT.pdf')

