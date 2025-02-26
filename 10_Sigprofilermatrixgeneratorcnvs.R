#######CREATED BY:MARTA PORTASANY#################
#############SIGPROFILERMATRIXGENERATOR###########
args <- commandArgs(trailingOnly = TRUE)
inputdata <- args[1]
pythondirectory <- args[2]
output <- args[3]
patient <- args[4]
sigprofilerfile <- args[5]
#log_file <- args[6]
##################################################
library("reticulate")
library("devtools")
##################################################
#inputdata <-"/home/user/MARTA/PULPO_ejecutadoprueba/results/Patients/Patient-71/SigProfiler/data/SigProfilerCNVdf.tsv"
#inputdata <-"/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-4/SigProfiler/data/SigProfilerCNVdf.tsv"
#output <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-4/SigProfiler/results/CNVs/"
#sigprofilerfile <-  "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients/Patient-2/SigProfiler/results/CNVs/MatrixGenerator/Patient-4.CNV48.matrix.tsv"
#patient<- "Patient-4"
#pythondirectory <- "/home/user/miniconda3/envs/PULPO/bin/python3.10"
#log_file <- "/home/user/MARTA/PULPO_RevisadoBionano/logs/Patients/Patient-4/SigProfiler/Sigprofiler/sigprofilercnvmatrixgenerator.log"
##################################################
use_python(pythondirectory)
py_config()
py_run_string("import sys")

#directorylog <- dirname(log_file)
#dir.create(directorylog,recursive = TRUE)
#file.create(log_file)
##################################################
tryCatch(
  {
    library(SigProfilerMatrixGeneratorR)  # Attempt to load the package
  },
  error = function(e) {
    # If there is an error, try to install the package
    message("The SigProfilerMatrixGeneratorR package is not installed. Proceeding to install it...")
    if (!requireNamespace("devtools", quietly = TRUE)) {
      install.packages("devtools")
    }
    devtools::install_github("AlexandrovLab/SigProfilerMatrixGeneratorR")
    library(SigProfilerMatrixGeneratorR)  # Attempt to reload again after installation
  }
)



#############
#############

tryCatch({
  # Read the file
  file <- read.table(inputdata, header = TRUE)
  
  # Check if the file has only headers (no data)
  if (nrow(file) == 0) {
    
    if (!dir.exists(output)) {
      dir.create(output, recursive = TRUE)
      message("Directory created:", output)
      # Create an empty file with only the headers
      file.create(sigprofilerfile)
    } else {
      message("The directory already exists:", output)
      # Create an empty file with only the headers
      file.create(sigprofilerfile)
    }
    
  } else {
    # Execute CNVMatrixGenerator function only if the file has data
    tryCatch({
      CNVMatrixGenerator(file_type = "PCAWG", input_file = inputdata, project = patient, output_path = output)
    }, error = function(e) {
      if (grepl("objeto 'sys' no encontrado", e$message)) {
        message("Advertencia: Se ignoró el error relacionado con 'sys' no encontrado.")
      } else {
        stop(e)  # Relanza otros errores
      }
    })
  }
}, error = function(e) {
  # Capture the error and display it
  message("An error occurred: ", e$message)
  print(patient)
  if (!dir.exists(output)) {
    dir.create(output, recursive = TRUE)
    message("Directory created:", output)
    # Create an empty file with only the headers
    file.create(sigprofilerfile)
  }
})

