#######CREATED BY:MARTA PORTASANY########
#############SIGPROFILEREXTRACTOR#################
#########################################
args <- commandArgs(trailingOnly = TRUE)
inputdata <- args[1]
pythondirectory <- args[2]
output <- args[3]
minimum_signatures <- args[4]
maximum_signatures <- args[5]
nmf_replicates <- args[6]
#########################################
library("reticulate")
library("devtools")
#########################################

if (!requireNamespace("SigProfilerExtractorR") == TRUE){
  install.packages("devtools", repos = "http://cran.us.r-project.org")
  devtools::install_github("AlexandrovLab/SigProfilerExtractorR")
  library("SigProfilerExtractorR")
  SigProfilerExtractorR::install("GRCh38", rsync=FALSE, bash=TRUE)
  
}else {
  message("SigProfilerExtractorR ya está instalado.")
  library("SigProfilerExtractorR")
}

###########SIGPROFILER##############
#library("SigProfilerMatrixGeneratorR")
#library("SigProfilerExtractorR")
#library("reticulate")
#library("devtools")
#########################################
#pythondirectory <- "/home/marta/mambaforge/envs/mutationalsignaturesOGM/bin/python3.10"
use_python(pythondirectory)
py_config()
py_run_string("import sys")
#install_github("AlexandrovLab/SigProfilerExtractorR")
#SigProfilerExtractorR::install("GRCh38", rsync=FALSE, bash=TRUE)
#inputdata <- "/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/results/Patient-4/SigProfiler/results/MatrixGenerator/Patient-4.SV32.matrix.tsv"
#output <- "/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/results/Patient-4/SigProfiler/results/Extractor/"
#########################################
# Función para comprobar si el archivo solo tiene la cabecera
is_empty_or_header_only <- function(file) {
  lines <- readLines(file, warn = FALSE)
  return(length(lines) == 1)  # Si solo hay una línea (la cabecera), no hay datos
}

# Comprobar si el archivo de entrada está vacío o solo tiene la cabecera
if (!file.exists(inputdata) || file.info(inputdata)$size == 0 || is_empty_or_header_only(inputdata)) {
  message("El archivo de entrada está vacío o solo contiene la cabecera. Creando un archivo de salida vacío y saliendo sin error.")
  
  # Asegurar que el directorio de salida existe
  if (!dir.exists(output)) {
    dir.create(output, recursive = TRUE)
  }
  
  # Crear un archivo vacío para que Snakemake no falle
  empty_output_file <- file.path(output, "empty_result.txt")
  file.create(empty_output_file)
  
  # Salir sin error
  quit(status = 0)
}



sigprofilerextractor("matrix", output, inputdata, reference_genome = "GRCh38",opportunity_genome = "GRCh38", minimum_signatures = minimum_signatures, maximum_signatures = maximum_signatures, nmf_replicates =nmf_replicates)
