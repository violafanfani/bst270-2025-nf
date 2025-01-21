


#!/usr/bin/env Rscript

# Load necessary libraries
suppressPackageStartupMessages(library(tidyverse))


# Get the directory of the current script
args <- commandArgs(trailingOnly = FALSE)
script_path <- sub("--file=", "", args[grep("--file=", args)][1])
script_dir <- dirname(normalizePath(script_path))

# Construct the path to the r_func directory
r_func_dir <- file.path(script_dir, "../r_func")

# Construct the path to the function file
for (fn in c("figure1.R")){
  print(fn)
  print(file.path(script_dir, "r_func", fn))
  source(file.path(script_dir, "r_func", fn))
}


# Function to parse command-line arguments
parse_args <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  
  if (length(args) != 2) {
    stop("Usage: Rscript process_files.R <input_file1> <input_file2> <output_file>")
  }
  
  list(input_file1 = args[1],  output_file = args[2])
}

  # Parse arguments
  args <- parse_args()
  
  # Read the input files
  data <- read.csv(args$input_file1, stringsAsFactors = FALSE)
  
  # Print values of mean and std
  print(mean(data$B1SORIEN))
  print(sd(data$B1SORIEN))
  
  # Print the sentence with substituted variables
  cat(sprintf(
    "We get mean (%.3f ± %.2f), ",
    mean(data$B1SORIEN), sd(data$B1SORIEN)
  ))
  
  
  #generate figure 1
  g1 = figure1(data) #print histogram
  
  ggsave(args$output_file, plot = g1, width = 6, height = 4, dpi = 300)
  
  
  message("Processing complete. Results saved to: ", args$output_file)



