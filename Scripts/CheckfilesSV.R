##############################################################################
# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)
patient <- args[1]
inputsv <- args[2]
error_log <- file.path(inputsv, "check_svs_error.txt")
##############################################################################

# Error handling function
manejar_error <- function(e) {
  mensaje_error <- paste0("ERROR: ", e$message, " in the sample ", patient, ".\n")
  writeLines(mensaje_error, con = error_log)  
  stop(mensaje_error) 
}

# Attempt to run the main code and capture errors
tryCatch({
  # Search for files with .smap extension in the input directory
  smap_files <- list.files(inputsv, pattern = "\\.smap$", full.names = TRUE)
  
  # Check if .smap files were found
  if (length(smap_files) == 0) {
    stop("No .smap files were found in the directory.")
  }
  
  # Process each .smap file found
  for (smap_file in smap_files) {
    # Read all lines of the file
    all_lines <- readLines(smap_file)
    
    # Filter lines without #
    variant_lines <- grep("^[^#]", all_lines, value = TRUE)
    
    # Check for variants after filtering
    if (length(variant_lines) == 0) {
      stop(paste0("The file ", smap_file, " for sample ", patient, " is empty."))
    } else {
      message(paste0("OK: THe file ", smap_file, " for sample ", patient, " has variants."))
    }
  }
}, error = manejar_error)
