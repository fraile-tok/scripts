#!/bin/bash

################################################################################
# PROKKA
################################################################################
module load prokka-master-gcc-9.3.0-j436ckw # Load prokka

for F in *.fna; do 
  echo "Processing file: $F";
  N=$(basename $F .fna) ; 
  echo "Locus tag: $N";
  prokka --kingdom Bacteria --cpus 20  --locustag "$N" --increment 1 --outdir "$N" --prefix "$N" "$F" ;
done

################################################################################
# ORTHOFINDER
################################################################################
module load orthofinder-2.2.0-gcc-9.3.0-g6x3cuu # Load orthofinder

mkdir -p orthofinder
cd orthofinder

ls ../*/*.faa | while read line; do ln -s $line .; done # Symbolic links

cd ../

orthofinder -f ./orthofinder -S diamond -M msa -t 40 -a 20 -n orthofinder_out

################################################################################
# IQTREE
################################################################################

mkdir -p iqtree
cd iqtree

module load miniconda3-4.9.2-gcc-9.3.0-mdbjxs2 # Load conda
conda activate iqtree # Activate conda environment w/iqtree

iqtree -m MFP -s ../orthofinder/Results_orthofinder_out_*/Orthologues_orthofinder_out_*/Aligments/SpeciesTreeAlignment.fa -B 1000 -T AUTO -ntmax 30

################################################################################
# Prep directories for get_homologues.pl
################################################################################

cd ../
mkdir -p get_homologues
cd get_homologues

ls ../*/*.gbk | while read line; do ln -s $line .; done # Symbolic links

cd ../
################################################################################
# Run get_homologues.pl
################################################################################

conda activate get_homologues # Activate conda environment w/get_homologues

# Define variables
get_homologues_path = /opt/spack/opt/spack/linux-ubuntu18.04-skylake_avx512/gcc-9.3.0/miniconda3-4.9.2-mdbjxs2dswmwcniwxq2lb6ap7rswdjbh/envs/get_homologues/bin/get_homologues.pl
pathDir=./get_homologues
numTaxa=$(ls -1 *.gbk 2>/dev/null | wc -l)
numCore=20

# Pangenoma
nohup $get_homologues_path -d "$pathDir" -t 0 -M -e -n "$numCore" > log_gh_pan.txt 2>&1

# Coregenoma
nohup $get_homologues_path -d "$pathDir" -t "$numTaxa" -M -e -n "$numCore" > log_gh_core_OMCL.txt 2>&1
nohup $get_homologues_path -d "$pathDir" -t "$numTaxa" -G -e -n "$numCore" > log_gh_core_COG.txt 2>&1
nohup $get_homologues_path -d "$pathDir" -t "$numTaxa" -e -n "$numCore" > log_gh_core_BDBH.txt 2>&1 &