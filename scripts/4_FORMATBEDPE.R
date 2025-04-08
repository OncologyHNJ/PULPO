# ==================================================
# Script: 4_FORMATBEDPE.R
# Description: First step to foramtting DATA needed to SigProfiler
# Author: Marta Portasany
# Created on: 2025-02-27
# Last modified: 2025-02-27
# Pipeline: PULPO
# Dependencies: stringr, readr#########################################
args <- commandArgs(trailingOnly = TRUE)
bionanodirectory <- args[1]
outputdirbaseSVs <- args[2]
############LOADS########################
library(gtools)
library(doParallel)
library(R.utils)
#########################################

output_folder <- "/ProcessData/"

createbedpe <- function(file_path, outputfolder,outputdirbaseSVs){
base_directory <- file_path
patients <- list.files(base_directory)

for (i in patients){
intermediarydir <- paste0(base_directory,"/",i,"/OGMdata/")
print(intermediarydir)
files <- list.files(intermediarydir)

files <- files[grepl("Rare_Variant_Analysis", files)]

smap_file <- files[grepl("\\.smap$", files)]
full_dir <- paste0(intermediarydir,smap_file)

#bedpe <- read.table(full_dir, header = FALSE)
output_dir <- paste0(outputdirbaseSVs, "/", i, output_folder)

# Crear el directorio solo si no existe
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

output_file <- paste0(output_dir, i, ".bedpe")


bedpe <- tryCatch(
  {
    read.table(full_dir, header = FALSE)
  },
  error = function(e) {
    message("The file is empty or cannot be read. An empty .bedpe file will be created.")
    bedpe_final_order <- data.frame()  # Return an empty data frame 
    write.table(bedpe_final_order, file = output_file, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
    message("The file is empty for patient ", i, ". Skipping.")
    return((NULL))
    
  }
)

if (is.null(bedpe) || nrow(bedpe) == 0) {
  message("Skipping patient ", i, " due to empty file.")
  next
}


chrom1 <- bedpe$V3
start1 <- round(bedpe$V7)
end1 <- round(bedpe$V7) + 10000
chrom2 <- bedpe$V4
start2 <- round(bedpe$V8)
end2 <- round(bedpe$V8) + 10000
name <- i
score <- bedpe$V10
strand <- bedpe$V24

library(magrittr)
library(tidyverse)


bedpefinal <- data.frame(chrom1=chrom1,start1=start1,end1=end1, chrom2=chrom2, start2=start2, end2=end2, name=name, score=score, strand=strand)

  bedpefinal <- bedpefinal %>%
    separate(strand, into = c("strand1", "strand2"), sep = "/")
  
  bedpefinal <- bedpefinal %>%
    mutate(strand1 = ifelse(is.na(strand1), ".", strand1))
  
  bedpefinal <- bedpefinal %>%
    mutate(strand2 = ifelse(is.na(strand2), ".", strand2))
  
  bedpe_final_order <- bedpefinal[order(bedpefinal$chrom1, bedpefinal$start1, bedpefinal$chrom2, bedpefinal$start2), ]
bedpe_final_order <- unique(bedpe_final_order)
write.table(bedpe_final_order, file = output_file, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)

}}

createbedpe(file_path = bionanodirectory, outputfolder = output_folder, outputdirbaseSVs = outputdirbaseSVs)
