#!/bin/bash
#cd ~/desulfobacteria
#change extension depending on data

################################################################################
# PROKKA
################################################################################

# FOLDER
#   RUN HERE
#   .fna's...

for F in *.fna; do 

  N=$(basename $F .fna) ; 
  prokka --kingdom Bacteria --cpus 20  --locustag $N --increment 1 --outdir $N $

done

################################################################################
# ORTHOFINDER
################################################################################

# FOLDER
#   RUN HERE
#   .fna's...
#   dir for each annotated genome

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

iqtree -m MFP -s ../orthofinder/Results_orthofinder_out_*/Orthologues_orthofinder_out_*/Aligments/SpeciesTreeAlignment.fa -B 1000 -T AUTO -ntmax 30

################################################################################
# Future Updates
# Prepare directories for get_homologues.pl (and compare_clusters.pl)
################################################################################