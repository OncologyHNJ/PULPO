#######CREATED BY:MARTA PORTASANY########
#############MERGEDCOHORT#################
#########################################
args <- commandArgs(trailingOnly = TRUE)
directorypatients <- args[1]
outputcohort <- args[2]
#########################################
#directorypatients <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Patients"
#"/home/marta/TESIS/OGM+WES/mutationalsignaturesOGM/results/Patient-1/SigProfiler/results/MatrixGenerator"
#outputcohort <- "/home/user/MARTA/PULPO_RevisadoBionano/results/Cohort/SVs/Cohort.SV32.matrix.tsv"
#########################################
# List all files in the patients directory
patients <- list.files(directorypatients)
directories <- list()
files <- list()

# Build the full paths for each file
for (i in patients) {
  fulldirectory <- paste0(directorypatients, "/", i, "/SigProfiler/results/SVs/MatrixGenerator/", i, ".SV32.matrix.tsv")
  directories <- c(directories, fulldirectory)
}

# Read the files and combine them into the 'files' list
for (j in directories) {
  if (file.exists(j)) {
    file <- read.table(j, header = TRUE)
    files <- append(files, list(file))  # Almacenar cada archivo como un elemento de la lista
  } else {
    warning(paste("El archivo", j, "no existe"))
  }
 # file <- read.table(j, header = TRUE)
#  files <- append(files, list(file))  # Store each file as an element in the list
}

# Convert the list of files into a single data frame
cohortfile <- files[[1]][1]  # Start with the first file

for (k in 1:length(files)) {
  if (nrow(files[[k]]) > 0 && ncol(files[[k]]) > 1) {  # Check if file is not empty and has more than one column
    # Get the column names from the current file
    col_names <- colnames(files[[k]])
    
    # Exclude the first column (MutationType) but keep the second column
    cohortfile <- cbind(cohortfile, files[[k]][2])
  } 
  else {
    message(paste("Some file is either empty or has only one row Skipping."))
  }
}

# Rename the columns to include patient names
#colnames(cohortfile) <- c("MutationType", paste0("Patient-", 1:(ncol(cohortfile)-1)))

# Remove the 'files.' prefix from the column names, if present
#colnames(cohortfile) <- sub("^files\\.", "", colnames(cohortfile))


write.table(cohortfile, file = outputcohort, sep = "\t", row.names = FALSE, quote = FALSE)


