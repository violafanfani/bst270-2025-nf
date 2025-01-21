#!/usr/bin/env Rscript

# Load necessary libraries
suppressPackageStartupMessages(library(tidyverse))



library(gtsummary)
library(tidyverse)

# Load the optparse library
library(optparse)

# Define optional command-line options
option_list <- list(
  make_option(c("--tertile1"), type = "double", default = 22,
              help = "First tertile [default: %default]"),
  make_option(c("--tertile2"), type = "double", default = 26,
              help = "second tertile [default: %default]")
)

# Parse options
opt_parser <- OptionParser(option_list = option_list, 
                           usage = "script.R [options] <data table> <output table 1>")
opt <- parse_args(opt_parser, positional_arguments = TRUE)

# Access positional arguments
if (length(opt$args) < 2) {
  stop("You must provide two non-optional arguments: <arg1> and <arg2>")
}

input_file <- opt$args[1]
output_table <- opt$args[2]


# Read the input files
df <- read.csv(input_file, stringsAsFactors = FALSE)

  # Access optional parameters
  t1 <- opt$options$tertile1
  t2 <- opt$options$tertile2

if ((t1==0) & (t2==0)){
  print("We compute tertiles now")
    t1 <- quantile(df$B1SORIEN, 1/3)
    t2 <- quantile(df$B1SORIEN, 2/3)
} else {
  # Access optional parameters
  t1 <- opt$options$tertile1
  t2 <- opt$options$tertile2
}

#Generating table for low, medium, and high optimism levels for corresponding lipid variables
#Visualize the mean and standard deviation using one-way ANOVA

df$Optimism<-cut(df$B1SORIEN,
                   breaks=c(-Inf,
                            t1,t2,
                            Inf),
                   labels=c("Low","Moderate","High"))

  table_1<-df|>
    select(Optimism,B4BCHOL,B4BHDL,B4BLDL,B4BTRIGL)|>
    tbl_summary(by=Optimism,
                label = list(
                  B4BCHOL ~ "Total cholesterol",
                  B4BTRIGL ~ "Triglycerides",
                  B4BHDL ~ "High-density lipoprotein cholesterol",
                  B4BLDL ~ "Low-density lipoprotein cholesterol"),
                statistic = all_continuous() ~ "{mean} ± {sd}",
                digits = list(all_continuous() ~ c(2, 2)))|>
    add_p(test = list(
      all_continuous() ~ "oneway.test")) |> 
    modify_spanning_header(all_stat_cols() ~"**Optimism**") #adds spanning header

  
  # Save as CSV
  table_data <- as_tibble(table_1, col_labels = TRUE)
  write.csv(table_data, output_table, row.names = FALSE)

message("Processing complete. Results saved to: ", output_table)



