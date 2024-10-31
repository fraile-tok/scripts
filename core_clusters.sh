#!/bin/bash
nohup compare_clusters.pl -d ./GenComp_160824_homologues/C4M0914_f0_149taxa_algBDBH_e1_,\
./GenComp_160824_homologues/C4M0914_f0_149taxa_algCOG_e1_,\
./GenComp_160824_homologues/C4M0914_f0_149taxa_algOMCL_e1_ -o coregenoma -t $numTaxa > log_core_250924_1.txt 2>&1
nohup compare_clusters.pl -d ./GenComp_160824_homologues/C4M0914_f0_149taxa_algBDBH_e1_,\
./GenComp_160824_homologues/C4M0914_f0_149taxa_algCOG_e1_,\
./GenComp_160824_homologues/C4M0914_f0_149taxa_algOMCL_e1_ -o coregenoma -t $numTaxa -n > log_core_250924_2.txt 2>&1 &


nohup compare_clusters.pl -d ./GenComp_160824_homologues/C4M0914_f0_0taxa_algOMCL_e1_ -m -o pagenoma > log_pan_250924.txt 2>&1 &