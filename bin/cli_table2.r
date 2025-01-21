
#!/usr/bin/env Rscript

# Load necessary libraries
suppressPackageStartupMessages(library(tidyverse))



library(gtsummary)
library(tidyverse)

# Load the optparse library
library(optparse)

# Parse options
opt_parser <- OptionParser(
                           usage = "script.R [options] <data table> <output table 1>")
opt <- parse_args(opt_parser, positional_arguments = TRUE)

# Access positional arguments
if (length(opt$args) < 2) {
  stop("You must provide two non-optional arguments: <arg1> and <arg2>")
}

input_file <- opt$args[1]
output_table <- opt$args[2]



# Read the input files
full_data <- read.csv(input_file, stringsAsFactors = FALSE)

fig2_cols <- c("Optimism", "Age", "Gender", "Race", "Education", "Income",
               "Interval between assessments", "Chronic conditions",
               "Blood pressure medication", "Body mass index", "Smoking status",
               "Alcohol consumption", "Prudent diet", "Regular exercise",
               "Negative affect")
cor_data <- full_data %>%
  mutate(Optimism = B1SORIEN,
         Age = as.numeric(age),
         Gender = case_when(sex == '(1) Male' ~ 0,
                            sex == '(2) Female' ~ 1),
         Race = case_when(race == 'White' ~ 0,
                          race == 'Nonwhite' ~ 1),
         Education = education_categorical,
         Income = household_income,
         `Interval between assessments` = visit_interval,
         `Chronic conditions` = case_when(chronic_condition == '(0) No' ~ 0,
                                          chronic_condition == '(1) Yes' ~ 1),
         `Blood pressure medication` = case_when(blood_pressure_med == '(2) No' | blood_pressure_med == '2' ~ 0,
                                                 blood_pressure_med == '1' ~ 1),
         `Body mass index` = BMI,
         `Smoking status` = case_when(smoking_status == '(1) current smoker' ~ 1,
                                      smoking_status == '(2) past smoker' ~ 2,
                                      smoking_status == '(3) never smoker' ~ 3),
         `Alcohol consumption` = drinks_per_day,
         `Prudent diet` = prudent_diet_score,
         `Regular exercise` = case_when(regular_exercise == '(2) No' ~ 0,
                                        regular_exercise == '(1) Yes' ~ 1),
         `Negative affect` = negative_affect) %>%
  select(all_of(fig2_cols))

results_df <- data.frame(matrix(ncol = 3, nrow = length(fig2_cols) - 1))
colnames(results_df) <- c("Characteristic", "r", "p")
for (i in seq(fig2_cols[-1])) {
  colname <- fig2_cols[-1][i]
  cor_val <- c(cor(cor_data[colname], cor_data$Optimism, method = 'pearson'))
  lm_model <- lm(cor_data$Optimism ~ unlist(cor_data[colname]))
  pval <- coef(summary(lm_model))[2, 'Pr(>|t|)']
  results_df$Characteristic[i] <- colname
  results_df$r[i] <- cor_val
  results_df$p[i] <- pval
}

results_df <- results_df %>%
  mutate(r = round(r, 2),
         p = case_when(p < 0.0001 ~ "<0.0001",
                       p < 0.001 ~ "<0.001",
                       TRUE ~ as.character(round(p, 2))))

#knitr::kable(results_df)
# Save the results_df as a CSV
write.csv(results_df, output_table, row.names = FALSE)