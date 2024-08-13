import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import ticker
import numpy as np
import argparse
from pathlib import Path
import math
import itertools

BAR_WIDTH = 0.8

TABLES = [0,1,2,4,5]
FILE = "../results-csv/iplookup-table.csv"
BUILD = ['CPU', 'DPU', 'CL', 'ROI']
TITLE_MAPPING = {0: "100", 1: "1K", 2: "10K", 4:"100K", 5:"1M"}
COLORS= {'CPU': "#5e8fb9", 'DPU': "#5aae53", 'CL': "#eb5d5d", 'ROI': "#f29696"}
SORT_DICT={s: i for i,s  in enumerate(BUILD)}


def process_csv_throughput(file_path):
    df = pd.read_csv(file_path)
    
    aggregated_df = df.groupby(['TABLE', 'build']).agg(
        # implem=('build', 'min'),
        lose_rate_mean=('LOSE-RATE', 'mean'),
        lose_rate_std=('LOSE-RATE', 'std'),
        rate_mean=('RX-RATE-MBPS', 'mean'),
        rate_std=('RX-RATE-MBPS', 'std'),
    ).reset_index()

    return aggregated_df


# from https://stackoverflow.com/a/78379749
def centered_subplots(rows,figsize=None):
    grid_dim=max(rows)
    grid_shape=(len(rows),2*grid_dim)
    if figsize:
        fig = plt.figure(figsize=(figsize))
    else:
        fig = plt.figure(figsize=(2*grid_dim,3*len(rows)))
    allaxes=[]
    jrow=0
    for row in rows:
        offset=0
        for i in range(row):
            if row<grid_dim:
                offset =grid_dim-row
                
            ax_position=(jrow,2*i+offset)
            ax = plt.subplot2grid(grid_shape, ax_position, fig=fig,colspan=2)
            allaxes.append(ax)
        jrow+=1
    return allaxes


if __name__=="__main__": 
    axs = centered_subplots([2,3], (10,5))

    df = None
    df = process_csv_throughput(FILE)

    for i, table_nbr in enumerate(TABLES):
        ax = axs[i]
        ax.grid(zorder=0, linestyle="dotted")

        xlabels = df[df.TABLE == table_nbr]['build']
        height = df[df.TABLE == table_nbr]['rate_mean']
        yerr = df[df.TABLE == table_nbr]['rate_std']

        xlabels, height, yerr = zip(*sorted(zip(xlabels, height, yerr), key=lambda val: SORT_DICT[val[0]]))
    
        positions = np.arange(len(xlabels))

        format_str = "%dMbps"
        if max(height) > 2000:
            height = np.array(height)/1000
            yerr=np.array(yerr)/1000
            format_str="%gGbps"

        ax.bar(positions, height, BAR_WIDTH, yerr=yerr, zorder=3, color=[COLORS[i] for i in xlabels])

    
        ax.set_xlabel('Implementation')
        ax.set_ylabel('Throughput')
        ax.yaxis.set_major_formatter(ticker.FormatStrFormatter(format_str))

        ax.set_xticks(positions)
        ax.set_xticklabels(xlabels)
        ax.tick_params(direction='in',which='both',axis='both',grid_linestyle='dotted',bottom='true',top='true',right='true',left='true',grid_color='#444444')

        ax.set_title(TITLE_MAPPING[table_nbr])
        ax.set_ylim(0)
    
    plt.tight_layout()
    plt.savefig(f'iplookup-RX-RATE.pdf')
