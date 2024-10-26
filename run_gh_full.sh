#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <pathDir> <numTaxa> <numCore>"
    exit 1
fi

get_homologues_path = /opt/spack/opt/spack/linux-ubuntu18.04-skylake_avx512/gcc-9.3.0/miniconda3-4.9.2-mdbjxs2dswmwcniwxq2lb6ap7rswdjbh/envs/get_homologues/bin/get_homologues.pl
pathDir=$1
numTaxa=$2
numCore=$3

echo "Starting up get_homologues. Remember to run with nohup."
echo "From directory:" $pathDir
echo "Total number of taxa:" $numTaxa
echo "Using cores:" $numCore

# Pangenoma
nohup $get_homologues_path -d "$pathDir" -t 0 -M -e -n "$numCore" > log_gh_pan.txt 2>&1

# Coregenoma
nohup $get_homologues_path -d "$pathDir" -t "$numTaxa" -M -e -n "$numCore" > log_gh_core_OMCL.txt 2>&1
nohup $get_homologues_path -d "$pathDir" -t "$numTaxa" -G -e -n "$numCore" > log_gh_core_COG.txt 2>&1
nohup $get_homologues_path -d "$pathDir" -t "$numTaxa" -e -n "$numCore" > log_gh_core_BDBH.txt 2>&1 &