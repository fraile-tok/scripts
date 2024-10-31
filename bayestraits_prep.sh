#!/bin/bash

# This script prepares the data for the BayesTraits analysis

# Para inputear el nombre del archivo en el comando
if [ -z "$1" ]; then
    echo "Need CSV filename."
    exit 1
fi

filename=$1

# Seleccionador automático de columnas
columns=$(head -1 $filename | awk -F"," '{print NF}')

let "columns-=1"

# Script Original (con ligeras modificaciones)
for file in $(seq 2 $columns); 
do 
    cut -d "," -f 1,$file,$((columns+1)) $filename \
        | sed 's/\"//g' | sed 's/\,/ /g'  > ${file}.txt; 
done

# s/nombredecolumna//
for file in *.txt; 
    do sed -i 's/desulfo//' $file; 
done

for file in *.txt; 
    do 
        sed -i "s/^\s//" $file; 
done

for i in *.txt;  
    do  d="$(head -1 "$i" | cut -d " " -f1).txt"; mv "$i" "$d"; 
done

for file in *.faa.txt; 
    do tail -n +2 $file > "${file/.faa.txt/_b.txt}"; 
done

