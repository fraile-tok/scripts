#!/bin/bash
source /opt/spack/opt/spack/linux-ubuntu18.04-skylake_avx512/gcc-9.3.0/miniconda3-4.9.2-mdbjxs2/etc/profile.d/conda.sh # Load conda

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

conda activate fastree # Activate conda environment w/FastTree (required for orthofinder)

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

conda activate iqtree # Activate conda environment w/iqtree

iqtree -m MFP -s ../orthofinder/Results_orthofinder_out_*/Orthologues_orthofinder_out_*/Aligments/SpeciesTreeAlignment.fa -B 1000 -T AUTO -ntmax 30

################################################################################
# Future Updates
# Prepare directories for get_homologues.pl (and compare_clusters.pl)
################################################################################