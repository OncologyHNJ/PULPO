#######CREATED BY:MARTA PORTASANY#################
#############SIGPROFILEREXTRACTORCOHORT###########
args <- commandArgs(trailingOnly = TRUE)
inputdata <- args[1]
output <- args[2]
patient <- args[3]
##################################################
inputdata <-  "/home/marta/Escritorio/PULPOPRUEBA/results/Patients/Prueba_Diag135/OGMdata/"
output <- "/home/marta/Escritorio/PULPOPRUEBA/results/Patients/Prueba_Diag135/SigProfiler/data/SigProfilerCNVdf.tsv"
patient <- "Prueba_Diag135"
##################################################
#setwd("./Escritorio/PULPOPRUEBA/results/Patients/Patient-1/OGMdata/")
pattern <- "CNV"
file_path <- list.files(path = inputdata, pattern = pattern, full.names = TRUE)
#cnv_files <- grep(pattern, inputdata, value = TRUE)
#list.files(inputdata)
#setwd(inputdata)
#list.files()

# Check if the file has only headers (i.e. no data)
if (length(file_path) == 0) {
  # Create an empty file with only the headers
  dfcnv <- data.frame(sample = character(), chromosome = character(), chromosome_start = numeric(), chromosome_end = numeric(), copy_number = numeric(), mutation_type = character())
  write.table(dfcnv, file = output, sep = "\t", row.names = FALSE, col.names = TRUE)
} else {
  ###FORMATITINGHEADERS###
  lines <- readLines(file_path)
  header_lines <- grep("^#", lines, value = TRUE)
  last_header_line <- tail(header_lines, 1)
  column_names <- strsplit(last_header_line, split = "\t")[[1]]
  column_names <- gsub("^#", "", column_names) # REMOVE '#'
  variant_lines <- grep("^#", lines, value = TRUE, invert = TRUE)
  
  if (length(variant_lines) == 0){
    dfcnv <- data.frame(sample = character(), chromosome = character(), chromosome_start = numeric(), chromosome_end = numeric(), copy_number = numeric(), mutation_type = character())
    write.table(dfcnv, file = output, sep = "\t", row.names = FALSE, col.names = TRUE)
  } else {
    
  txt <- list.files(path = inputdata, pattern = "txt", full.names = TRUE)
  csv <- list.files(path = inputdata, pattern = ".csv", full.names = TRUE)
  if (length(txt) == 1) {
    filecnv <- read.table(file_path, header = FALSE, sep = "\t", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
    colnames(filecnv) <- column_names 
    chromosome <- filecnv$Chromosome
    chromosome_start <- round(filecnv$Start)
    chromosome_end <- round(filecnv$End)
    copy_number <- filecnv$CopyNumber
    mutation_type <- gsub("(loss|gain)_masked", "\\1", filecnv$Type)
    sample <- patient
    dfcnv <- data.frame(sample, chromosome, chromosome_start, chromosome_end, copy_number, mutation_type)
   # dir.create(output, recursive = TRUE)
    write.table(dfcnv, file = output, sep = "\t", row.names = FALSE, col.names = TRUE)
  }
  else if (length(csv) == 1){
    filecnv <- read.csv(file_path,header = TRUE)
    chromosome <- filecnv$Chromosome
    chromosome_start <- filecnv$Start
    chromosome_end <- filecnv$End
    copy_number <- filecnv$CopyNumber
    mutation_type <- gsub("(loss|gain)_masked", "\\1", filecnv$Type)
    sample <- patient
    dfcnv <- data.frame(sample,chromosome,chromosome_start, chromosome_end, copy_number, mutation_type)
    write.table(dfcnv, file = output, sep = "\t", row.names = FALSE, col.names = TRUE)
  }
  
 
} }

