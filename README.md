# GPU NPF

This repo was used for our work on [GPU-based packet processing](https://dial.uclouvain.be/downloader/downloader_thesis.php?pid=thesis:45872&datastream=PDF_01&key=7d2f4507527b7a32725824c3f3467a3d).

The measures in this work were made using the scripts in this repo. All the scripts require [NPF](https://github.com/tbarbette/npf). NPF needs to be in the same folder as this repo or be in the PATH.

### Execution

The script can be executed by running the command:

```
sh npf-script.s
```

To forward the --force-retest parameter to NPF, to force remaking all measures, the following command can be used:

```
sh npf-script.s -r
```

### Folders
The *results* folders contain csv files with the results of our experiments or the outputs files from npf.
The *ip-table-plotting*, *zlt-plotting*, *graphs* and *compare* folders contain the pdf graphs and the python scripts used to generate the graphs.
The *baseline*, *ethermirror*, *iplookukp*, *crc*, *doca* and *shared* folders contain the npf scripts used to make the measures.
The *saved_vector* bin files are used for the IP Lookup measures.
The *cluster* folder give information about the nodes in the network to NPF.
