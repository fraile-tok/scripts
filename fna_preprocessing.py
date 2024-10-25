import os
import shutil
base_dir = "/Users/jpiglesias/Documents/UNAM/TESIS/outgroup_dataset/ncbi_dataset/data/"
fna_directory = "/Users/jpiglesias/Documents/UNAM/TESIS/outgroup_dataset/ncbi_dataset/data/fna/"


for folder in os.listdir(base_dir):
    folder_path = os.path.join(base_dir, folder)

    if os.path.isdir(folder_path):
        for file in os.listdir(folder_path):
            if file.endswith(".fna"):
                new_name = file.split(".1_")[0] + ".fna" # rename

                old_path = os.path.join(folder_path, file)
                new_path = os.path.join(fna_directory, new_name)

                shutil.move(old_path, new_path) # moves file
                print(f"Moved: {file} -> {new_name} in 'fna' folder")

from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

for fna_file in os.listdir(fna_directory):
    if fna_file.endswith(".fna"):
        file_path = os.path.join(fna_directory, fna_file)
        
        # Extract base name for the new header (filename without extension)
        base_name = os.path.basename(file_path).replace('.fna', '')
    
        # Concatenate all sequences from the file
        combined_sequence = ''.join(str(record.seq) for record in SeqIO.parse(file_path, "fasta"))
    
        # Create a new SeqRecord with the combined sequence and the new header
        new_record = SeqRecord(Seq(combined_sequence), id=base_name, description="")
    
        # Overwrite the original file with the renamed single contig
        SeqIO.write(new_record, file_path, "fasta")
    
        print(f"Processed: {os.path.basename(file_path)} -> New header: {base_name}")

        print(f"File {fna_file} processed.")