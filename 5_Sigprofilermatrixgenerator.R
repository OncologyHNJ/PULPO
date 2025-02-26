#######CREATED BY:MARTA PORTASANY########
#############SIGPROFILER#################
#########################################
args <- commandArgs(trailingOnly = TRUE)
inputdata <- args[1]
pythondirectory <- args[2]
output <- args[3]
patientid <- args[4]
###########SIGPROFILER##############
#install.packages("Sigprofilerextractor")
#install.packages("reticulate")
#install.packages("devtools")
#########################################
library(reticulate)
#pythondirectory <-"/home/marta/mambaforge/envs/mutationalsignaturesOGM/bin/python3"
use_python(pythondirectory)
py_config()
py_run_string("import sys")
#library(devtools)
#library(SigProfilerExtractorR)
library(SigProfilerMatrixGeneratorR)
#library(reticulate)
#library(devtools)
#install("GRCh38", rsync=FALSE, bash=TRUE)
#library(SigProfilerMatrixGeneratorR)
#install_github("AlexandrovLab/SigProfilerMatrixGeneratorR", force= TRUE)
#install('GRCh38', rsync=FALSE, bash=TRUE)
###############DATA################################################################################################################################
#inputdata <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-46/SigProfiler/data/SigProfilerSVdf.bedpe"
#inputtry <- "/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/results/Patient-1/SigProfiler/try/"
#outputtry <- "/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/results/Patient-1/SigProfiler/try"
#inputdata <- "/home/marta/Descargas/try"
#pythondirectory <- "/home/user/miniconda3/envs/PULPO/bin/python3.10"
#output <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-46/SigProfiler/results/MatrixGenerator/"
#patientid <- "Patient-46"
##################################################################################################################################################
#inputdata <- "/home/marta/Descargas/try"
#patientid <- "try"
#output <-"/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/try2"

##################################################################################################################################################
#use_python(pythondirectory)
#py_config()
########SIGPROFILERMATRIXGENERATOR############################
is_empty_or_header_only <- function(file) {
  lines <- readLines(file, warn = FALSE)
  return(length(lines) == 1)  # Si solo hay una línea (la cabecera), no hay datos
}

# Comprobar si el archivo de entrada está vacío o solo tiene la cabecera
if (!file.exists(inputdata) || file.info(inputdata)$size == 0 || is_empty_or_header_only(inputdata)) {
  message("The input file is empty or contains only the header. Creating an empty output file and exiting without error.")
  
  # Asegurar que el directorio de salida existe
  if (!dir.exists(output)) {
    dir.create(output, recursive = TRUE)
  }
  
  # Crear un archivo vacío para que Snakemake no falle
  empty_output_file <- file.path(output, patientid, ".SV32.matrix.tsv")
  file.create(empty_output_file)
  
  # Salir sin error
  quit(status = 0)
}

tryCatch({
  SigProfilerMatrixGeneratorR::SVMatrixGenerator(input_dir = inputdata, project = patientid, output_dir = output)
}, error = function(e) {
  message("Captured error: ", e)
})
