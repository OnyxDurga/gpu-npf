# GPU NPF

This repo was used for our work on GPU-based packet processing:

> Van Hauwaert, Romain ; Vanliefde, Maxime. GPU-based Packet Processing.  Ecole polytechnique de Louvain, Université catholique de Louvain, 2024. Prom. : Barbette, Tom. http://hdl.handle.net/2078.1/thesis:45872

The measures in this work were made using the scripts in this repo. All the scripts require [NPF](https://github.com/tbarbette/npf). NPF needs to be available in the parent folder or be in the PATH.

### Execution

The script expects `npf` to be in the parent folder.
It can be executed by running the command:

```
sh npf-script.s
```

To forward the --force-retest parameter to NPF, to force remaking all measures, the following command can be used:

```
sh npf-script.s -r
```

### Zero-loss Throughput Exploration
ZLT exploration can be enabled by adding `--exp-design "zlt(RATE,RX-GOODPUT-GBPS-PKTGEN)"` to any NPF command. In that case, set the RATE variable to `[1-100#1]` to specify the range you want to explore.

### Folders
The *results* folders contain csv files with the results of our experiments or the outputs files from npf.  
The *ip-table-plotting*, *zlt-plotting*, *graphs* folders contain the pdf graphs and the python scripts used to generate the graphs, if any.  
The *baseline*, *ethermirror*, *iplookukp*, *crc* and *shared* folders contain the npf scripts used to make the measures.  
The *saved_vector* bin files are used for the IP Lookup measures.  
The *cluster* folder give information about the nodes in the network to NPF.  
