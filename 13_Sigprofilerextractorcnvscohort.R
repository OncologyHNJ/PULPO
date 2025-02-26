#######CREATED BY:MARTA PORTASANY########
#############SIGPROFILEREXTRACTOR########
#########################################
args <- commandArgs(trailingOnly = TRUE)
inputdata <- args[1]
pythondirectory <- args[2]
output <- args[3]
minimum_signatures <- args[4]
maximum_signatures <- args[5]
nmf_replicates <- args[6]
errorlog <- args[7]
###########SIGPROFILER##############
library("SigProfilerExtractorR")
library("reticulate")
library("devtools")
#########################################
inputdata <-"/home/user/MARTA/PULPO_ejecutadoprueba/results/Cohort/CNVs/Cohort.CNV48.matrix.tsv"
#pythondirectory <- "/home/user/miniconda3/envs/PULPO/bin/python3.10"
#output <- "/home/marta/TESIS/OGM+WES/PULPO_ejecutadoprueba/results/Cohort/SigProfiler/"
output <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Cohort/CNVs/SigProfiler/Extractor/Prueba3"
#filecnv <- read.table(inputcohort,header=TRUE)
#minimum_signatures <- "1"
#maximum_signatures <- "10"
#nmf_replicates <- "5"
#inputdata <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Cohort/CNVs/SigProfiler/MatrixGenerator/Cohort.CNV48.matrix.tsv"
#########################################
use_python(pythondirectory)
py_config()
#########################################

#sigprofilerextractor("matrix", output, inputdata, reference_genome = "GRCh38",opportunity_genome = "GRCh38", minimum_signatures=minimum_signatures, maximum_signatures=maximum_signatures, nmf_replicates=nmf_replicates, min_nmf_iterations = 1000, max_nmf_iterations =100000, nmf_test_conv = 1000, nmf_tolerance = 0.00000001)

sigprofilerextractor("matrix", output, inputdata, reference_genome = "GRCh38",opportunity_genome = "GRCh38", minimum_signatures=1, maximum_signatures=25, nmf_replicates=500, min_nmf_iterations = 1000, max_nmf_iterations =100000, nmf_test_conv = 1000, nmf_tolerance = 0.00000001)
