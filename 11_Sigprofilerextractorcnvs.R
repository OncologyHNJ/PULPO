#######CREATED BY:MARTA PORTASANY########
#############SIGPROFILEREXTRACTOR########
#########################################
args <- commandArgs(trailingOnly = TRUE)
inputdata <- args[1]
pythondirectory <- args[2]
outputdata <- args[3]
min_signatures <- args[4]
max_signatures <- args[5]
nmf_replicates <- args[6]
errorlog <- args[7]
###########SIGPROFILER##############
library("reticulate")
library("devtools")

if (!requireNamespace("SigProfilerExtractorR") == TRUE){
  install.packages("devtools", repos = "http://cran.us.r-project.org")
  devtools::install_github("AlexandrovLab/SigProfilerExtractorR")
  library("SigProfilerExtractorR")
  SigProfilerExtractorR::install("GRCh38", rsync=FALSE, bash=TRUE)
  
}else {
  message("SigProfilerExtractorR ya está instalado.")
  library("SigProfilerExtractorR")
}
#########################################
#inputdata <- "/home/user/MARTA/PULPO_ejecutadoprueba/results/Patient-83/SigPiler/results/CNVs/Patient-83.CNV48.matrix.tsv"
#inputdata <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-1/SigProfiler/results/CNVs/MatrixGenerator/Patient-1.CNV48.matrix.tsv"
#inputcohort <- "/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/cohort/cohort.CNV48.matrix.tsv"
#pythondirectory <- "/home/user/miniconda3/envs/PULPO/bin/python3.10"
#outputdata <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-1/SigProfiler/results/CNVs/Extractor/"
#outputcohort <- "/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/cohort/results/SigProfiler/CNVs/"
#filecnv <- read.table(inputcohort,header=TRUE)
#min_signatures <- "1"
#max_signatures <- "10"
#nmf_replicates <- "5"
#errorlog <- "/home/user/MARTA/PULPO_ejecutadoprueba/logs/Patients/Patient-1/SigProfilerExtractor/Error_log.tsv"
##ERROR PATIENT 4/18 Error en py_call_impl(callable, call_args$unnamed, call_args$named): ValueError: Length of values (1) does not match length of index (3)
##ERROR PATIENT 6 -Error en py_call_impl(callable, call_args$unnamed, call_args$named): ValueError: operands could not be broadcast together with shapes (48,0) (0,0) 
#########################################
use_python(pythondirectory)
py_config()
#########################################
directorylog <- dirname(errorlog)
dir.create(directorylog,recursive = TRUE)
file.create(errorlog)
exists(inputdata)
if (file.exists(inputdata) == FALSE) {
  dir.create(outputdata, recursive = TRUE)
  writeLines(inputdata, errorlog, sep = "\n")
} else{
  sigprofilerextractor("matrix", outputdata, inputdata, reference_genome = "GRCh38", minimum_signatures=min_signatures , maximum_signatures=max_signatures, nmf_replicates = nmf_replicates, min_nmf_iterations = 1000, max_nmf_iterations =100000, nmf_test_conv = 1000, nmf_tolerance = 0.00000001)
}

#sigprofilerextractor("matrix", "/home/user/MARTA/PULPO_RevisadoBionano/results/Cohort/prueba/", inputdata, reference_genome = "GRCh38", minimum_signatures=1 , maximum_signatures=10, nmf_replicates = 5, min_nmf_iterations = 1000, max_nmf_iterations =100000, nmf_test_conv = 1000, nmf_tolerance = 0.00000001)

