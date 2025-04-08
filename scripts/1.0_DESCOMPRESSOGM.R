# ==================================================
# Script: 1.0_DESCOMPRESSOGM.R
# Description: Descompression of OGM raw data as a first step in the PULPO pipeline
# Author: Marta Portasany
# Created on: 2025-02-27
# Last modified: 2025-02-27
# Pipeline: PULPO
# Dependencies: stringr, readr
# ==================================================
library(stringr)
library(readr)
#===================================================
args <- commandArgs(trailingOnly = TRUE)
ogmdirectory <- args[1]
workdirectory <- args[2]
samplesfile <- args[3]


filter_and_remove_files <- function(directory) {
  # Define search patterns
  smap_pattern <- "\\.smap$"  # Allow any file ending with .smap
  cnv_pattern <- "CNV"        # Allow any file containing "CNV"
  
  # List all files in the directory
  files_in_directory <- list.files(directory, full.names = TRUE)
  cat("Files in the directory:", files_in_directory, "\n")
  
  # Iterate over files and remove unwanted ones
  for (file_path in files_in_directory) {
    file_name <- basename(file_path)
    
    # Check if the file does not match any of the patterns
    if (!(str_detect(file_name, smap_pattern) | str_detect(file_name, cnv_pattern))) {
      file.remove(file_path)
      cat("File removed:", file_name, "\n")
    }
  }
}

samples <- read_tsv(samplesfile, col_types = cols())

# Check for required columns
if (!all(c("bionano", "anonymised") %in% colnames(samples))) {
  stop("The configuration file must contain the columns 'bionano' and 'anonymised'.")
}

for (i in samples$bionano) {
  actualdirectory <- file.path(ogmdirectory, i)
  print(actualdirectory)
  
  # Check if the directory exists
  if (!dir.exists(actualdirectory)) {
    warning(paste("Directory does not exist:", actualdirectory))
    next
  }
  
  # Change to the current directory
  setwd(actualdirectory)
  
  # List files in the current directory
  filesinsample <- list.files(actualdirectory)
  print(filesinsample)
  
  # Find .zip files
  zipfiles <- grep("\\.zip$", filesinsample, value = TRUE)
  print(zipfiles)
  if (length(zipfiles) > 1) {
    ZIP <- grep("BED_ALL|SV_CNV|BED", zipfiles, value = TRUE, invert = TRUE)
    print(ZIP)
    if (length(ZIP) == 1) {
      
      # Define the destination directory based on the anonymised column
      anonymised_name <- samples$anonymised[samples$bionano == i]
      OGMdescompressdirectory <- file.path(workdirectory, "results/DATA/Patients", anonymised_name, "OGMdata/")
      
      dir.create(OGMdescompressdirectory, showWarnings = FALSE, recursive = TRUE)
      
      # Unzip the .zip file into the specified directory
      unzip(ZIP, exdir = OGMdescompressdirectory)
      print(paste("File decompressed into:", OGMdescompressdirectory))
      
      # Filter and remove unwanted files
      filter_and_remove_files(OGMdescompressdirectory)
    }
    
    OGMdescompressdirectory <- file.path(workdirectory, "results/DATA/Patients", anonymised_name, "OGMdata/")
    files <- list.files(OGMdescompressdirectory)
    annotated_smap_files <- grep("^(?!.*Annotated).*\\.smap$", files, value = TRUE, perl = TRUE)
    if (length(annotated_smap_files) > 0){
      
      print(annotated_smap_files)
      directoryremove <- file.path(OGMdescompressdirectory,annotated_smap_files)
      print(paste("File remove:", directoryremove))
      file.remove(directoryremove)
    }
  } 
  if (length(zipfiles) == 1) { 
    ZIP <- grep("*.zip", zipfiles, value = TRUE)
    print(ZIP)
    anonymised_name <- samples$anonymised[samples$bionano == i]
    OGMdescompressdirectory <- file.path(workdirectory, "results/DATA/Patients", anonymised_name, "OGMdata/")
    ##DESCOMPRIMIR EL ZIP
    # Unzip the .zip file into the specified directory
    unzip(ZIP, exdir = OGMdescompressdirectory)
    print(paste("File decompressed into:", OGMdescompressdirectory))
    filter_and_remove_files(OGMdescompressdirectory)
    files <- list.files(OGMdescompressdirectory)
    annotated_smap_files <- grep("^(?!.*Annotated).*\\.smap$", files, value = TRUE, perl = TRUE)
    if (length(annotated_smap_files) > 0){
      
      print(annotated_smap_files)
      directoryremove <- file.path(OGMdescompressdirectory,annotated_smap_files)
      print(paste("File remove:", directoryremove))
      file.remove(directoryremove)
    }
  }
  
}
