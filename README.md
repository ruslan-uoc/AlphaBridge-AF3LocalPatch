# !!! This fork is deprecated as now AlphaBrideg supports the output from AlphaFold3. 

# AlphaFold3 Local Installation Compatability Patch for AlphaBridge

This is the fork of the original AlphaBridge directory containing several bash and python scripts enabling the usage of local AlphaFold3 output by making it match the format of AlphaFoldServer.

## Installation and Output Files

Instructions for installation of AlphaBridge and the information about the output format can be found in original repository:
https://github.com/PDB-REDO/AlphaBridge/tree/trunk

## How to run the script

1. Place your AF3 output files in directory AF3input

2. Run the script

You can either provide the desired seed number (put 1 if AF3 was used with a single seed) or use "best" functionality in which case the program will check ranking_scores.csv to find the seed with the best ranking scores.

```console
bash run.sh
Usage: run.sh <seed_number> | best
```

## Cleanup Scripts

You can either use

```console
bash cleanup.sh
```

Or:

```console
bash cleanupAFS.sh
```

Cleanup.sh will purge all files in AF3input, AFSConv, and AlphaBridge_output. CleanupAFS.sh will not affect AF3input and will remove all files edited by the program instead.

## DEMO EXAMPLE

```console
bash run.sh best
```

The output will be saved in AlphaBridge_output directory.
