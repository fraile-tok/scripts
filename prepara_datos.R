#Este escript prepara la matriz pangenomica obtenida apartir del algoritmo de clusterizacion de homologos OMCL
#Elaboró MC. Ulises Erick Rodriguez Cruz
#Modificaciones posteriores por José Pablo Iglesias Serrano
#Laboratorio de Evolución Molecular y experimental
#Instituto de Ecología, UNAM

setwd("~/Documents/UNAM/TESIS/Odd_Ratio/")

library(readr)
library(dplyr)
library(tibble)
library(plyr)
library(tidyverse)
library(ape)
library(phylotools)

pangenoma <- read.csv(file = "pangenome_matrix_t0.tr.csv",header = T,row.names = 1,check.names = F)
pangenoma[,c("Non-unique Gene name","Annotation","No. isolates","No. sequences","Avg sequences per isolate","Genome fragment"
             ,"Order within fragment","Accessory Fragment","Accessory Order with Fragment","QC","Min group size nuc"
             ,"Max group size nuc","Avg group size nuc")] <- NULL
pangenoma_t <- t(pangenoma)
rownames(pangenoma_t) <- str_replace(rownames(pangenoma_t),".gbk", "")

#Generar csv.s para dummy's
rownames_df <- cbind(row.names = rownames(pangenoma_t))
write.csv(rownames_df, "1_dummy.csv", row.names = FALSE)
write.csv(rownames_df, "2_dummy.csv", row.names = FALSE)
write.csv(rownames_df, "unos.csv", row.names = FALSE)
write.csv(rownames_df, "ceros.csv", row.names = FALSE)

#Para buscar genes con corr. positiva (Datos 1's, Referencia 0's)
dummy_1 <- read.csv(file = "1_dummy.csv",header = T,row.names = 1, check.names = F)
rownames(dummy_1) <- str_replace(rownames(dummy_1),".gbk", "")
colnames(dummy_1) <- "1_dummy.faa"

#Para buscar genes con corr. negativa (Datos 0's, Referencia 1's)
dummy_2 <- read.csv(file = "2_dummy.csv",header = T,row.names = 1, check.names = F)
rownames(dummy_2) <- str_replace(rownames(dummy_2),".gbk", "")
colnames(dummy_2) <- "2_dummy.faa"

#Juntar pangenoma con vectores dummy
pangenoma_t_2 <- merge(pangenoma_t,dummy_1,by = "row.names")
pangenoma_t_2 <- pangenoma_t_2 %>%
  column_to_rownames("Row.names")

pangenoma_t_3 <- merge(pangenoma_t_2,dummy_2,by = "row.names")
pangenoma_t_3 <- pangenoma_t_3 %>%
  column_to_rownames("Row.names")

# (1, no. genomas)
unos <- rep(1,149) #repite (1, n número de veces)
unos <- as.data.frame(unos)
rownames(unos) <- rownames(pangenoma_t_3)
colnames(unos) <- "unos.faa"

ceros <- rep(0,149) #repite (0, n número de veces)
ceros <- as.data.frame(ceros)
rownames(ceros) <- rownames(pangenoma_t_3)
colnames(ceros) <- "ceros.faa"

pangenoma_t_4 <- merge(pangenoma_t_3,ceros,by = "row.names")
pangenoma_t_4 <- pangenoma_t_4 %>%
  column_to_rownames("Row.names")

pangenoma_t_5 <- merge(pangenoma_t_4, unos,by = "row.names")
pangenoma_t_5 <- pangenoma_t_5 %>%
  column_to_rownames("Row.names")
#write.csv(x = pangenoma_t_5,file = "matriz_pangenoma_hip1.csv")

# desulfo.csv es igual al dummy 1, columna de vectores en colnames
hip1 <- read.csv(file = "desulfo.csv",header = T,row.names = 1,check.names = F)
rownames(hip1) <- str_replace(rownames(hip1),".gbk", "")
colnames(hip1) <- "desulfo"

pangenoma_t_6 <- merge(pangenoma_t_5,hip1, by = "row.names")
pangenoma_t_6 <- pangenoma_t_6 %>%
  column_to_rownames("Row.names")
write.csv(x = pangenoma_t_6,file = "matriz_pangenoma_cc.csv")


