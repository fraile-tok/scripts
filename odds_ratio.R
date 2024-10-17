#Elaboró MC. Ulises Erick Rodriguez Cruz
#Modificaciones posteriores por José Pablo Iglesias Serrano
#Laboratorio de Evolución Molecular y experimental
#Instituto de Ecología, UNAM

setwd("~/Documents/UNAM/TESIS/Odd_Ratio/")

library(dplyr)
library(tidyverse)

longitud <- as.data.frame(read.csv(file = "1_dummy.csv",check.names = F,header = T,row.names = 1))
pangenoma <- as.data.frame(read.csv(file = "matriz_pangenoma_cc.csv",row.names = 1, header = T,check.names = F))
pangenoma_t <- pangenoma

largo_crom <- longitud %>%
  rownames_to_column('ciano') %>%
  filter(longitud ==1) %>%
  column_to_rownames('ciano')
names_h <- as.data.frame(rownames(largo_crom))
names_h <- as.character(names_h$`rownames(largo_crom)`)

cort_crom <- longitud %>% 
  rownames_to_column('ciano') %>%
  filter(longitud == 0) %>%
  column_to_rownames('ciano')
names_l <- as.data.frame(rownames(cort_crom))
names_l <- as.character(names_l$`rownames(cort_crom)`)

largo_pang <- pangenoma_t[names_h,] #organismos con abundancia alta de HIP1 y presencia/ausencia del gen
corto_pang <- pangenoma_t[names_l,] #organismos con abundancia baja de HIP y presencia ausencia de gen

gen_nogen_largo_crom <- largo_pang + 1
gen_nogen_corto_crom <- corto_pang

prueba <- sapply(gen_nogen_largo_crom, table)

data_1 <-prueba %>% 
  map(bind_rows) %>%
  bind_rows(.id = 'genes_1') %>%
  column_to_rownames('genes_1')

prueba_3 <- sapply(gen_nogen_corto_crom, table)

data_2 <- prueba_3 %>%
  map(bind_rows) %>%
  bind_rows(.id = 'genes_2')%>%
  column_to_rownames('genes_2')

toodds <- cbind(data_1,data_2)
#toodds$genes_2 <- NULL
toodds[is.na(toodds)] <- 0
#toodds <- toodds %>% 
#  column_to_rownames("genes_1")
colnames(toodds) <- c("bipcc_ausente", "bipcc_presente","ref_ausente","ref_presente")

odds_ratio <- ((toodds$bipcc_presente)*(toodds$ref_ausente))/((toodds$bipcc_ausente)*(toodds$ref_presente))
odds_ratio <- as.data.frame(odds_ratio)
odds_ratio$Var1 <- NULL
rownames(odds_ratio) <- rownames(toodds)

toodds <- merge(toodds,odds_ratio,by = "row.names")
toodds <- toodds %>%
  column_to_rownames("Row.names")

filtros <- toodds %>% 
  rownames_to_column("genes") %>%
  filter(
           bipcc_ausente <4 &
             bipcc_presente >2 & 
           ref_presente <= 0)%>%
  column_to_rownames("genes")

write.csv(x = filtros,file = "proteinas_especificas_de_asgard_CC.csv")

# Presentes en CC, pero no Referencias
si_cc_no_ref <- toodds %>%
  rownames_to_column("genes") %>%
  filter(bipcc_presente > 1 & ref_presente <= 0) %>%
  column_to_rownames("genes")

write.csv(x = si_cc_no_ref, file="proteinas_presentes_solo_CC.csv")

#unir las tablas de odds ratio con la de pvalor

pval_bayestraits <- read.csv(file = "./resultados_bayestraits/valores_p_asgard.csv",header = T,row.names = 1)
pval_bayestraits <- pval_bayestraits %>% rownames_to_column("genes") %>%
  filter(genes != "ceros.faa") %>%
  filter(genes != "unos.faa") %>%
  column_to_rownames("genes")

odds_pval_tamanio <- merge(pval_bayestraits,toodds,by= "row.names",all.x = T)
odds_pval_tamanio <- odds_pval_tamanio %>%
  column_to_rownames("Row.names")
colnames(odds_pval_tamanio) <- c("pvalue","bipcc_ausente","bipcc_presente","ref_ausente","ref_presente","odd_ratio")
col_order <- c("bipcc_ausente","bipcc_presente","ref_ausente","ref_presente","odd_ratio","pvalue")
odds_pval_tamanio <- odds_pval_tamanio[ c("bipcc_ausente","bipcc_presente","ref_ausente","ref_presente","odd_ratio","pvalue")]
odds_pval_tamanio$fdr <- p.adjust(odds_pval_tamanio$pvalue ,method = "fdr")
odds_pval_tamanio$bonferroni <- p.adjust(odds_pval_tamanio$pvalue ,method = "bonferroni")

write.csv(x = odds_pval_tamanio, file = "odds_ratio_p_value_tamanio_genoma_OMCL_vectores_dummuhip1.csv",row.names = T)


filtros <- odds_pval_tamanio %>% 
  rownames_to_column("genes") %>%
  filter(
           ref_presente <= 0 &
           bonferroni < 0.05
           ) %>%
  column_to_rownames("genes")

rownames(filtros)

corr_neg <- odds_pval_tamanio %>% 
  rownames_to_column("genes") %>%
  filter(positivo_presente <= 5 & 
           positivo_ausente <= 1) %>%
  column_to_rownames("genes")

